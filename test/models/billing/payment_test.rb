require 'test_helper'

module Billing
  class PaymentTest < ActiveSupport::TestCase
    setup do
      @payment = billing_payments(:one)
      @account = @payment.account
    end
    
    # test "args_to_attributes class method" do
      # payment_type = billing_payment_type(:one)
      # assert_equal Billing::Payment.args_to_attributes(), {}
      # assert_equal Billing::Payment.args_to_attributes(payment_type.id), { payment_type_id: payment_type.id }
      # assert_equal Billing::Payment.args_to_attributes(billing_payment_type(:one)), { payment_type_id: payment_type.id }
      # assert_equal Billing::Payment.args_to_attributes(payment_type_id: 2, value: 0.23), { payment_type_id: 2, value: 0.23 }
    # end
    
    test "create" do
      assert_equal 'Billing::PaymentWithType', @account.origin_payment_model
      assert @account.payments.create(type: 'Billing::PaymentWithType', value: 1, payment_type_id: @payment.payment_type_id).persisted?, "Can't create payment"
    end
    
    test "should be instance of account's origin_payment_model" do
      payment = @account.payments.new(type: 'Billing::Payment', value: 1, payment_type_id: @payment.payment_type_id)
      assert !payment.save
      assert payment.errors.messages[:account]
    end
    
    test "should have same fiscal flag as other account payments" do
      payment = @account.payments.new(type: 'Billing::PaymentWithType', value: 1, payment_type_id: billing_payment_types(:fiscal).id)
      assert !payment.save
      assert payment.errors.messages[:account]
    end
    
    test "should be single cash payments" do
      @account.payments.create!(type: 'Billing::PaymentWithType', value: 1, payment_type: billing_payment_types(:cash))
      payment = @account.payments.new(type: 'Billing::PaymentWithType', value: 1, payment_type_id: billing_payment_types(:cash).id)
      assert !payment.save
      assert payment.errors.messages[:account]
    end
  end
end
