module Billing
  class PaymentWithType < Payment
    belongs_to :payment_type, inverse_of: :payments
    delegate :payment_types, to: :account
    
    validates_presence_of :payment_type
    validates :payment_type, inclusion: { in: :payment_types }
    
    after_initialize on: :create do
      self.payment_type = billable.try(:default_payment_type) unless payment_type
    end
    
  end
end