require 'test_helper'

module Billing
  class AccountTest < ActiveSupport::TestCase
    setup do
      @account = billing_accounts(:one)
      @account.save! # force summary calculation
    end
    
    test "charge" do
      charge = @account.charge 3
      assert charge.persisted?
      assert_equal '13 USD'.to_money, @account.total # (1 + 3) + 100% + $1
    end
    
    test "discount" do
      discount = @account.modify(-1.00)
      assert discount.persisted?
      assert_equal '6 USD'.to_money, @account.total
    end
    
    test "surcharge" do
      surcharge = @account.modify(1.00)
      assert surcharge.persisted?
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
      assert @account.errors[:total]
      assert_raise ActiveRecord::RecordInvalid do
        @account.save!
      end
    end
  end
end
