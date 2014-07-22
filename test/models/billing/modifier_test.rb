require 'test_helper'

module Billing
  class ModifierTest < ActiveSupport::TestCase
    setup do
      @modifier = billing_modifiers(:one)
    end
    
    # test "args_to_attributes class method" do
      # assert_equal Billing::Modifier.args_to_attributes("1%"), { percent: 1 }
      # assert_equal Billing::Modifier.args_to_attributes("22.1 %"), { percent: 22.1 }
      # assert_equal Billing::Modifier.args_to_attributes(1.456), { fixed_value: '1.46 USD'.to_money }
      # assert_equal Billing::Modifier.args_to_attributes("1.4"), { fixed_value: '1.4 USD'.to_money }
      # assert_equal Billing::Modifier.args_to_attributes("1.4EUR"), { fixed_value: '1.4 EUR'.to_money }
      # assert_equal Billing::Modifier.args_to_attributes(1, percent_ration: 0.01 ), { fixed_value: '1 USD'.to_money, percent: 0.01 }
      # assert_equal Billing::Modifier.args_to_attributes(percent_ration: 0.01), { percent_ratio: 0.01 }
    # end
    
    test "allow only one modifier per charge" do
      mod = billing_modifiers(:two).dup
      assert_equal false, mod.save
      assert mod.errors[:charge]
    end
    
    test "allow only one global account modifier" do
      mod = billing_modifiers(:two).dup
      assert_equal false, mod.save
      assert mod.errors[:account]
    end
    
  end
end
