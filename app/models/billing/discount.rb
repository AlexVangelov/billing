module Billing
  class Discount < ActiveRecord::Base
    include AccountItem
    belongs_to :account, inverse_of: :discounts
    belongs_to :charge
    monetize :fixed_value_cents
    
    class << self
      def args_to_attributes(*args)
        case args.first.class
        when Hash then
          {}.merge(*args)
        when String then
          d = args.shift
          if d.index('%')
            
          end
        else
          h = { price: args.shift.to_money }
          args.any? ? h.merge(*args) : h
        end
      end
    end
  end
end
