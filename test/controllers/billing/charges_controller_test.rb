require 'test_helper'

module Billing
  class ChargesControllerTest < ActionController::TestCase
    setup do
      @charge = billing_charges(:one)
      @account = @charge.account  
    end
    
    test "should get new" do
      get :new, account_id: @account
      assert_response :success
    end

  end
end
