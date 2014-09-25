module Billing
  class Payment < ActiveRecord::Base
    PAYMENT_WITH_TYPE = 'Billing::PaymentWithType'.freeze
    PAYMENT_EXTERNAL = 'Billing::PaymentExternal'.freeze
    PAYPAL_EXPRESS = 'Billing::PaypalExpress'.freeze
    PAYMENT_MODELS = [PAYMENT_WITH_TYPE, PAYMENT_EXTERNAL, PAYPAL_EXPRESS].freeze
    
    include BillItem
    
    attr_writer :origin
    attr_accessor :origin_id
    monetize :value_cents

    belongs_to :bill, inverse_of: :payments, validate: true
    
    scope :in_period, lambda {|from, to| where(created_at: from..to) }
    scope :for_report, -> { joins(:bill).where(billing_bills: { balance_cents: 0 ,report_id: nil }) }
    
    if defined? Extface
      belongs_to :extface_job, class_name: 'Extface::Job'
    end
    
    delegate :billable, to: :bill

    validates_numericality_of :value, greater_than_or_equal_to: 0
    validates :type, inclusion: { in: PAYMENT_MODELS }
    
    after_initialize on: :create do
      self.value = -bill.try(:balance) if value.zero?
    end
    
    def fiscal?; false; end
    def cash?; false; end
    def external?; false; end
    
    def origin
      @origin || origins.find_by_id(@origin_id)
    end
    
    private
      class << self
        def wild_args(*args)
          h = {}
          case when args.blank? || args.first.kind_of?(Hash) then
            args.blank? ? h : h.merge(*args)
          when args.first.kind_of?(String) then
              #TODO parse
          else
            h.merge!(payment_type_id: args.shift.to_param)
            if args.any? && (args.first.kind_of?(Hash) || args.first.kind_of?(String))
              h.merge(args(*args))
            else
              if args.blank?
                h
              else
                h.merge!( value: args.shift.to_money )
                args.any? ? h.merge(*args) : h
              end
            end
          end
        end
      end
  end
end
