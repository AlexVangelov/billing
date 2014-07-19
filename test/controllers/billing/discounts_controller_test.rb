require 'test_helper'

module Billing
  class DiscountsControllerTest < ActionController::TestCase
    setup do
      @discount = billing_discounts(:one)
      @account = @discount.account  
    end

    test "should get new" do
      get :new, account_id: @account
      assert_response :success
    end

  end
end
