require 'test_helper'

class CadetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cadet = cadets(:one)
  end

  test "should get index" do
    get cadets_url
    assert_response :success
  end

  test "should get new" do
    get new_cadet_url
    assert_response :success
  end

  test "should create cadet" do
    assert_difference('Cadet.count') do
      post cadets_url, params: { cadet: { available: @cadet.available, document: @cadet.document, email: @cadet.email, first_name: @cadet.first_name, last_name: @cadet.last_name, position: @cadet.position, status: @cadet.status } }
    end

    assert_redirected_to cadet_url(Cadet.last)
  end

  test "should show cadet" do
    get cadet_url(@cadet)
    assert_response :success
  end

  test "should get edit" do
    get edit_cadet_url(@cadet)
    assert_response :success
  end

  test "should update cadet" do
    patch cadet_url(@cadet), params: { cadet: { available: @cadet.available, document: @cadet.document, email: @cadet.email, first_name: @cadet.first_name, last_name: @cadet.last_name, position: @cadet.position, status: @cadet.status } }
    assert_redirected_to cadet_url(@cadet)
  end

  test "should destroy cadet" do
    assert_difference('Cadet.count', -1) do
      delete cadet_url(@cadet)
    end

    assert_redirected_to cadets_url
  end
end
