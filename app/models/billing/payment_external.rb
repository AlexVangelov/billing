module Billing
  class PaymentExternal < Payment
    validates_presence_of :external_token
    
    def external?; true; end
    
  end
end