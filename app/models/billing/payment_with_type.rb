module Billing
  class PaymentWithType < Payment
    belongs_to :payment_type, inverse_of: :payments
    
    delegate :fiscal?, :cash?, to: :payment_type, allow_nil: true
    
    validates_presence_of :payment_type
    validates :payment_type, inclusion: { in: :payment_types }
    
    after_initialize on: :create do
      self.payment_type = default_payment_type unless payment_type
    end
    
    private
      def default_payment_type
        if pt = billable.try(:default_payment_type)
          pt
        else
          bill.try(:payment_types).try(:first) unless bill.try(:payment_types).try(:many?)
        end
      end
    
  end
end