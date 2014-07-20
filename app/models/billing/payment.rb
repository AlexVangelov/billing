module Billing
  class Payment < ActiveRecord::Base
    include AccountItem
    belongs_to :account, inverse_of: :payments, validate: true
    
    monetize :value_cents
    
    delegate :billable, to: :account
    
    validates_presence_of :value
    
    after_initialize on: :create do
      if account.try(:valid?)
        self.value = account.total if value.zero?
      end
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
