require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  test "should get details" do
    get :details
    assert_response :success
  end

end
