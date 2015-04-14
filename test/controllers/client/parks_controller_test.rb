require 'test_helper'

class Client::ParksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
