require 'test_helper'

class Client::BaseControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
