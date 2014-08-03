require 'test_helper'

module Billing
  class PaymentTest < ActiveSupport::TestCase
    setup do
      @payment = billing_payments(:one)
      @bill = @payment.bill
    end
    
    # test "args_to_attributes class method" do
      # payment_type = billing_payment_type(:one)
      # assert_equal Billing::Payment.args_to_attributes(), {}
      # assert_equal Billing::Payment.args_to_attributes(payment_type.id), { payment_type_id: payment_type.id }
      # assert_equal Billing::Payment.args_to_attributes(billing_payment_type(:one)), { payment_type_id: payment_type.id }
      # assert_equal Billing::Payment.args_to_attributes(payment_type_id: 2, value: 0.23), { payment_type_id: 2, value: 0.23 }
    # end
    
    test "create" do
      assert_equal 'Billing::PaymentWithType', @bill.origin_payment_model
      assert @bill.payments.create(type: 'Billing::PaymentWithType', value: 1, payment_type_id: @payment.payment_type_id).persisted?, "Can't create payment"
    end
    
    test "should be instance of bill's origin_payment_model" do
      payment = @bill.payments.new(type: 'Billing::Payment', value: 1, payment_type_id: @payment.payment_type_id)
      assert !payment.save
      assert payment.errors.messages[:bill]
    end
    
    test "should have same fiscal flag as other bill payments" do
      payment = @bill.payments.new(type: 'Billing::PaymentWithType', value: 1, payment_type_id: billing_payment_types(:fiscal).id)
      assert !payment.save
      assert payment.errors.messages[:bill]
    end
    
    test "should be single cash payments" do
      @bill.payments.create!(type: 'Billing::PaymentWithType', value: 1, payment_type_id: billing_payment_types(:cash).id)
      payment = @bill.payments.new(type: 'Billing::PaymentWithType', value: 1, payment_type_id: billing_payment_types(:cash).id)
      assert !payment.save
      assert payment.errors.messages[:bill]
    end
  end
end
