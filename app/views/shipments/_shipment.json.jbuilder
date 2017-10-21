json.extract! shipment, :id, :origin_lat, :origin_lng, :destiny_lat, :destiny_lng, :sender_id, :receiver_id, :receiver_email, :price, :final_price, :cadet_id, :status, :sender_pays, :receiver_pays, :delivery_time, :payment_method, :created_at, :updated_at
json.url shipment_url(shipment, format: :json)
