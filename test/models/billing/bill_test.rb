require 'test_helper'

module Billing
  class BillTest < ActiveSupport::TestCase
    setup do
      @bill = billing_bills(:one)
      @bill.charges.each(&:save!) #update values
      @bill.save! # force summary calculation
    end
    
    test "summaries" do
      assert_equal '3 USD'.to_money, @bill.charges_sum
      assert_equal '3 USD'.to_money, @bill.surcharges_sum
      assert_equal '0 USD'.to_money, @bill.discounts_sum
      assert_equal '3 USD'.to_money, @bill.payments_sum
      assert_equal '6 USD'.to_money, @bill.total
      assert_equal '-3 USD'.to_money, @bill.balance
    end
    
    test "charge" do
      charge = @bill.charge 3
      assert_difference "@bill.charges.count" do
        assert @bill.save!
      end
      assert charge.persisted?
      assert_equal '12 USD'.to_money, @bill.total
    end
   
    test "discount" do
      discount = @bill.modify(-1.00, charge: billing_charges(:two))
      #c = billing_charges(:two)
      assert_difference "@bill.modifiers.count" do
        assert @bill.save
      end
      assert discount.try(:persisted?)
      assert_equal '6 USD'.to_money, @bill.total  # ((1+1) + (2-1)) + 100%
    end

    test "surcharge" do
      surcharge = @bill.modify(1.00, charge: billing_charges(:two))
      assert_difference "@bill.modifiers.count" do
        assert @bill.save
      end
      assert surcharge.try(:persisted?)
      assert_equal '6 USD'.to_money, @bill.total
    end
    
    test "pay with qty" do
      @bill = billing_bills(:open)
      @bill.charge qty: 1.5, price: 10
      assert_difference "@bill.charges.count" do
        assert @bill.save
      end
      payment = @bill.pay type: 'Billing::PaymentWithType', payment_type: billing_payment_types(:cash)
      assert_difference "@bill.payments.count" do
        assert @bill.save
      end
      assert @bill.balance.zero?
      assert_equal '15 USD'.to_money, @bill.payments_sum
    end
=begin    
    test "validate positive total" do
      assert @bill.save
      @bill.modify(-500)
      assert @bill.errors.messages[:total]
      assert_raise ActiveRecord::RecordInvalid do
        @bill.save!
      end
    end
    
    test "bill with payments should have origin" do
      assert @bill.origin
      assert @bill.payments.any?
      @bill.origin = nil
      assert_equal false, @bill.save
      assert @bill.errors.messages[:origin]
    end
    
    test "autofin" do
      assert @bill.pay billing_payment_types(:one)
      assert @bill.finalized_at
    end
=end
  end
end
