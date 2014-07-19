require 'test_helper'

module Billing
  class PaymentTest < ActiveSupport::TestCase
    setup do
      @payment = billing_payments(:one)
    end
    
    test "args_to_attributes class method" do
      payment_type = billing_payment_type(:one)
      assert_equal Billing::Payment.args_to_attributes(), {}
      assert_equal Billing::Payment.args_to_attributes(payment_type.id), { payment_type_id: payment_type.id }
      assert_equal Billing::Payment.args_to_attributes(billing_payment_type(:one)), { payment_type_id: payment_type.id }
      assert_equal Billing::Payment.args_to_attributes(payment_type_id: 2, value: 0.23), { payment_type_id: 2, value: 0.23 }
    end
  end
end
