module Billing
  class Payment < ActiveRecord::Base
    include AccountItem
    belongs_to :account, inverse_of: :payments, validate: true
    monetize :value_cents
    
    validates_presence_of :value
    
    class << self
      def args(*args)
        case when args.blank? || args.first.kind_of?(Hash) then
          {}.merge(*args)
        when args.first.kind_of?(String) then
            #TODO parse
        else
          h = { value: args.shift.to_money }
          args.any? ? h.merge(*args) : h
        end
      end
    end
  end
end
