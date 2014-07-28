require 'test_helper'

module Billing
  class AccountTest < ActiveSupport::TestCase
    setup do
      @account = billing_accounts(:one)
      @account.save! # force summary calculation
    end
    
    test "charge" do
      charge = @account.charge 3
      assert charge.try(:persisted?)
      assert_equal '13 USD'.to_money, @account.total # (1 + 3) + 100% + $1
    end
    
    test "discount" do
      discount = @account.modify(-1.00, charge: billing_charges(:two))
      assert discount.try(:persisted?)
      assert_equal '6 USD'.to_money, @account.total
    end
    
    test "surcharge" do
      surcharge = @account.modify(1.00, charge: billing_charges(:two))
      assert surcharge.try(:persisted?)
      assert_equal '8 USD'.to_money, @account.total
    end
    
    test "pay" do
      payment = @account.pay billing_payment_types(:one)
      assert @account.balance.zero?, @account.errors.full_messages.join(', ')
      assert_equal '7 USD'.to_money, @account.payments_sum
    end
    
    test "validate positive total" do
      assert @account.save
      @account.modify(-500)
      assert @account.errors.messages[:total]
      assert_raise ActiveRecord::RecordInvalid do
        @account.save!
      end
    end
    
    test "account with payments should have origin" do
      assert @account.origin
      assert @account.payments.any?
      @account.origin = nil
      assert_equal false, @account.save
      assert @account.errors.messages[:origin]
    end
    
    test "autofin" do
      assert @account.pay billing_payment_types(:one)
      assert @account.finalized_at
    end
  end
end
