module Billing
  class ModifierItems < Array
    def discounts
      select{ |m| m.price < 0.to_money }
    end
    
    def surcharges
      select{ |m| m.price > 0.to_money }
    end
  end
end