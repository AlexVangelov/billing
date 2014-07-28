module Billing
  class PaymentWithType < Payment
    belongs_to :payment_type, inverse_of: :payments
    
    validates_presence_of :payment_type
    validates :payment_type, inclusion: { in: :payment_types }
    
    after_initialize on: :create do
      self.payment_type = default_payment_type unless payment_type
    end
    
    def fiscal?
      payment_type.fiscal
    end
    
    def cash?
      payment_type.cash
    end
    
    private
      def default_payment_type
        if pt = billable.try(:default_payment_type)
          pt
        else
          account.payment_types.try(:first) unless account.payment_types.many?
        end
      end
    
  end
end