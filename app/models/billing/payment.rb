module Billing
  class Payment < ActiveRecord::Base
    PAYMENT_WITH_TYPE = 'Billing::PaymentWithType'.freeze
    PAYMENT_EXTERNAL = 'Billing::PaymentExtrernal'.freeze
    PAYPAL_EXPRESS = 'Billing::PayPalExpress'.freeze
    PAYMENT_MODELS = [PAYMENT_WITH_TYPE, PAYMENT_EXTERNAL, PAYPAL_EXPRESS].freeze
    
    include AccountItem
    
    attr_writer :origin, :origin_id
    monetize :value_cents

    belongs_to :account, inverse_of: :payments, validate: true
    
    scope :in_period, lambda {|from, to| where(created_at: from..to) }
    
    if defined? Extface
      belongs_to :extface_job, class_name: 'Extface::Job'
    end
    
    delegate :billable, to: :account

    validates_numericality_of :value, greater_than_or_equal_to: 0
    validates :type, inclusion: { in: PAYMENT_MODELS }
    
    after_initialize on: :create do
      self.value = -account.try(:balance).to_money if value.zero?
    end
    
    before_validation do
      account.origin = origin unless account.origin and account.payments.many?
    end
    
    def self.new(attributes = nil, options = {}, &block)
      payment_model = super(attributes, options, &block).origin.try(:payment_model)
      super(attributes.merge(type: payment_model), options, &block)
    end
    
    def fiscal?; false; end
    def cash?; false; end
    def external?; false; end
    
    def origin
      @origin || origins.find_by_id(@origin_id)
    end
    
    private
      class << self
        def args(*args)
          h = { type: 'Billing::PaymentWithType' }
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
