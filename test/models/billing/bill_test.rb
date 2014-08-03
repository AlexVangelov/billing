require 'test_helper'

module Billing
  class BillTest < ActiveSupport::TestCase
    setup do
      @bill = billing_bills(:one)
      @bill.save! # force summary calculation
    end
    
    test "charge" do
      charge = @bill.charge 3
      assert charge.try(:persisted?)
      assert_equal '13 USD'.to_money, @bill.total # (1 + 3) + 100% + $1
    end
    
    test "discount" do
      discount = @bill.modify(-1.00, charge: billing_charges(:two))
      assert discount.try(:persisted?)
      assert_equal '6 USD'.to_money, @bill.total
    end
    
    test "surcharge" do
      surcharge = @bill.modify(1.00, charge: billing_charges(:two))
      assert surcharge.try(:persisted?)
      assert_equal '8 USD'.to_money, @bill.total
    end
    
    test "pay" do
      payment = @bill.pay billing_payment_types(:one)
      assert @bill.balance.zero?, @bill.errors.full_messages.join(', ')
      assert_equal '7 USD'.to_money, @bill.payments_sum
    end
    
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
  end
end
