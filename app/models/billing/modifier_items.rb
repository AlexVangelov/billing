module Billing
  class ModifierItems < Array
    def discounts
      select{ |m| m.price < 0 }
    end
    
    def surcharges
      select{ |m| m.price > 0 }
    end
  end
end