require 'test_helper'

module Billing
  class ChargeTest < ActiveSupport::TestCase
    setup do
      @charge = billing_charges(:one)
    end
    
    test "wild class method" do
      assert_equal Billing::Charge.new(Billing::Charge.wild_args(1)).price, '1 USD'.to_money
      assert_equal Billing::Charge.new(Billing::Charge.wild_args("1")).price, '1 USD'.to_money
      assert_equal Billing::Charge.new(Billing::Charge.wild_args("1EUR")).price, '1 EUR'.to_money
      assert_equal Billing::Charge.new(Billing::Charge.wild_args('1', price_currency: 'EUR')).price, '1 EUR'.to_money
      assert_equal Billing::Charge.new(Billing::Charge.wild_args(price: 10, price_currency: 'EUR')).price, '10 EUR'.to_money
    end
    
    test "string protocol" do
      charge = Billing::Charge.new Billing::Charge.wild_args("2.5*3.5##{billing_plus(:one).id}@#{billing_tax_groups(:one).id}+1.5%/Umbrella")
      assert_equal charge.price, '3.5 USD'.to_money
      assert_equal charge.name, 'Umbrella'
      #p charge
    end
    
    test "qty" do
      charge = Billing::Charge.new price: 0.95, qty: 2.0
      assert_equal charge.price, '0.95'.to_money
      assert_equal charge.qtyprice, '1.90'.to_money
    end
  end
end
