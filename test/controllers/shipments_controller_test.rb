require 'test_helper'

class ShipmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shipment = shipments(:one)
  end

  test "should get index" do
    get shipments_url
    assert_response :success
  end

  test "should get new" do
    get new_shipment_url
    assert_response :success
  end

  test "should create shipment" do
    assert_difference('Shipment.count') do
      post shipments_url, params: { shipment: { cadet_id: @shipment.cadet_id, delivery_time: @shipment.delivery_time, destiny_lat: @shipment.destiny_lat, destiny_lng: @shipment.destiny_lng, final_price: @shipment.final_price, origin_lat: @shipment.origin_lat, origin_lng: @shipment.origin_lng, payment_method: @shipment.payment_method, price: @shipment.price, receiver_email: @shipment.receiver_email, receiver_id: @shipment.receiver_id, receiver_pays: @shipment.receiver_pays, sender_id: @shipment.sender_id, sender_pays: @shipment.sender_pays, status: @shipment.status } }
    end

    assert_redirected_to shipment_url(Shipment.last)
  end

  test "should show shipment" do
    get shipment_url(@shipment)
    assert_response :success
  end

  test "should get edit" do
    get edit_shipment_url(@shipment)
    assert_response :success
  end

  test "should update shipment" do
    patch shipment_url(@shipment), params: { shipment: { cadet_id: @shipment.cadet_id, delivery_time: @shipment.delivery_time, destiny_lat: @shipment.destiny_lat, destiny_lng: @shipment.destiny_lng, final_price: @shipment.final_price, origin_lat: @shipment.origin_lat, origin_lng: @shipment.origin_lng, payment_method: @shipment.payment_method, price: @shipment.price, receiver_email: @shipment.receiver_email, receiver_id: @shipment.receiver_id, receiver_pays: @shipment.receiver_pays, sender_id: @shipment.sender_id, sender_pays: @shipment.sender_pays, status: @shipment.status } }
    assert_redirected_to shipment_url(@shipment)
  end

  test "should destroy shipment" do
    assert_difference('Shipment.count', -1) do
      delete shipment_url(@shipment)
    end

    assert_redirected_to shipments_url
  end
end
