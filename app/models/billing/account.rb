module Billing
  class Account < ActiveRecord::Base
    monetize :charges_sum_cents
    monetize :discounts_sum_cents
    monetize :payments_sum_cents
    monetize :total_cents
    monetize :balance_cents
    
    belongs_to :billable, polymorphic: true
    has_many :charges, inverse_of: :account
    has_many :discounts, inverse_of: :account
    has_many :payments, inverse_of: :account
    
    accepts_nested_attributes_for :charges, :discounts, :payments
    
    before_save :update_sumaries
    
    def charge(*args)
      charges.create Charge.args_to_attributes(*args)
    end
    
    def discount(*args)
      dicounts.create Discount.args_to_attributes(*args)
    end
    
    def pay(*args)
      payments.create Payment.args_to_attributes(*args)
    end
    
    def discount_items
      calculate_discounts
    end

    private
      def calculate_discounts
        @discount_items = [].tap() do |items|
          discounts.each do |discount|
            if charge = discount.charge
              items << Charge.new(price: charge.price * discount.percent_ratio, chargable: charge)
            else
              items << Charge.new(price: charges.sum(&:price).to_money * discount.percent_ratio)
            end
          end
        end
      end
      def update_sumaries
        self.charges_sum = charges.sum(&:price).to_money
        calculate_discounts
        self.discounts_sum = @discount_items.sum(&:price).to_money
        self.payments_sum = payments.sum(&:value).to_money
        self.total = charges_sum - discounts_sum
        self.balance = payments_sum - total
      end
  end
end
