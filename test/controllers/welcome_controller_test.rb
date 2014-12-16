require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get map" do
    get :map
    assert_response :success
  end

end
