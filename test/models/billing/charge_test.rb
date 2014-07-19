require 'test_helper'

module Billing
  class ChargeTest < ActiveSupport::TestCase
    setup do
      @charge = billing_charges(:one)
    end
    
    test "args_to_attributes class method" do
      assert_equal Billing::Charge.args_to_attributes(1), { price: '1 USD'.to_money }
      assert_equal Billing::Charge.args_to_attributes("1"), { price: '1 USD'.to_money }
      assert_equal Billing::Charge.args_to_attributes("1 EUR"), { price: '1 EUR'.to_money }
      assert_equal Billing::Charge.args_to_attributes(1, price_currency: 'USD'), { price: '1 USD'.to_money, price_currency: 'USD' }
      assert_equal Billing::Charge.args_to_attributes(price: 10, price_currency: 'EUR'), { price: 10, price_currency: 'EUR' }
    end
  end
end
