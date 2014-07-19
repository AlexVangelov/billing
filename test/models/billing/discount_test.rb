require 'test_helper'

module Billing
  class DiscountTest < ActiveSupport::TestCase
    setup do
      @discount = billing_discounts(:one)
    end
    
    test "args_to_attributes class method" do
      assert_equal Billing::Discount.args_to_attributes("1%"), { percent: 1 }
      assert_equal Billing::Discount.args_to_attributes("22.1 %"), { percent: 22.1 }
      assert_equal Billing::Discount.args_to_attributes(1.456), { fixed_value: '1.46 USD'.to_money }
      assert_equal Billing::Discount.args_to_attributes("1.4"), { fixed_value: '1.4 USD'.to_money }
      assert_equal Billing::Discount.args_to_attributes("1.4EUR"), { fixed_value: '1.4 EUR'.to_money }
      assert_equal Billing::Discount.args_to_attributes(1, percent_ration: 0.01 ), { fixed_value: '1 USD'.to_money, percent: 0.01 }
      assert_equal Billing::Discount.args_to_attributes(percent_ration: 0.01), { percent_ratio: 0.01 }
    end
  end
end
