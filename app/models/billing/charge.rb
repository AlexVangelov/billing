module Billing
  class Charge < ActiveRecord::Base
    include AccountItem
    belongs_to :account, inverse_of: :charges
    belongs_to :chargable, polymorphic: true
    monetize :price_cents
    
    validates_presence_of :price
    
    class << self
      def args_to_attributes(*args)
        if args.first.is_a? Hash
          {}.merge(*args)
        else
          h = { price: args.shift.to_money }
          args.any? ? h.merge(*args) : h
        end
      end
    end
  end
end
