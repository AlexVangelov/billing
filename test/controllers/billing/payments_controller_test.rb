require 'test_helper'

module Billing
  class PaymentsControllerTest < ActionController::TestCase
    setup do
      @payment = billing_payments(:one)
      @account = @payment.account  
    end

    test "should get new" do
      get :new, account_id: @account
      assert_response :success
    end

  end
end
