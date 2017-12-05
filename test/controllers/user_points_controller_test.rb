require 'test_helper'

class UserPointsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_points_index_url
    assert_response :success
  end

end
