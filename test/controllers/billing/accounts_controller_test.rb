require 'test_helper'

module Billing
  class AccountsControllerTest < ActionController::TestCase
    setup do
      @account = billing_accounts(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
    end

    test "new" do
      get :new
      assert_response :success
    end
  end
end
