require 'test_helper'

module Billing
  class ModifiersControllerTest < ActionController::TestCase
    setup do
      @modifier = billing_modifiers(:one)
      @account = @modifier.account  
    end

    test "should get new" do
      get :new, account_id: @account
      assert_response :success
    end

  end
end
