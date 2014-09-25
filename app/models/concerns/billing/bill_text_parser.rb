module Billing
  module BillTextParser

    def parse_qty(qty_s)
      nil
    end
    
    def parse_plu(plu_s)
      nil
    end
    
    def parse_text(text)
      #p text
      text[1..-1] if text
    end

  end
end