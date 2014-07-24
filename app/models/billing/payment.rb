module Billing
  class Payment < ActiveRecord::Base
    include AccountItem
    
    attr_writer :origin, :origin_id

    belongs_to :account, inverse_of: :payments, validate: true
    
    monetize :value_cents
    
    delegate :billable, to: :account

    validates_numericality_of :value, greater_than_or_equal_to: 0
    validates :type, inclusion: { in: proc { |p| [p.account.origin_payment_model] } }
    
    after_initialize on: :create do
      self.value = -account.try(:balance).to_money if value.zero?
    end
    
    before_validation do
      account.origin = origin unless account.origin and account.payments.many?
    end
    
    private
      def origin
        @origin || origins.find_by_id(@origin_id)
      end
    
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
