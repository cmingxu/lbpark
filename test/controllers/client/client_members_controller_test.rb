require 'test_helper'

class Client::ClientMembersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
