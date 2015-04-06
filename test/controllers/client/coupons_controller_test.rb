require 'test_helper'

class Client::CouponsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
