require 'test_helper'

class CadetSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get cadet_sessions_new_url
    assert_response :success
  end

end
