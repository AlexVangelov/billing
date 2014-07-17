require 'test_helper'

module Billing
  class PaymentsControllerTest < ActionController::TestCase
    test "should get new" do
      get :new
      assert_response :success
    end

  end
end
