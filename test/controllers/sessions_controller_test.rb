require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
<<<<<<< HEAD
  test "should get create" do
    get sessions_create_url
    assert_response :success
  end

  test "should get destroy" do
    get sessions_destroy_url
=======
  
  test "should get new" do
    get '/login'
>>>>>>> bdf19928bb4d0cd8d28c15dbff9eab42ecd8c1fc
    assert_response :success
  end

end
