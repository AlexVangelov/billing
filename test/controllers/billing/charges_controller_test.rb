require 'test_helper'

module Billing
  class ChargesControllerTest < ActionController::TestCase
    test "should get new" do
      get :new
      assert_response :success
    end

  end
end
