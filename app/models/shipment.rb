class Shipment < ApplicationRecord
  has_attached_file :confirm_reception, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :confirm_reception, content_type: /\Aimage\/.*\z/
  attr_accessor :confirm_reception_url
    
    def self.allFromJson(jsonShipments)
        @shipments =  jsonShipments.map do |js| 
            Shipment.fromJson(js)
        end
    #  jsonShipments.each do |jsonShipment|
    #     shipment = Shipment.fromJson(jsonShipment)
    #     @shipments << shipment
    #     end
    end
    
    def self.fromJson(jsonShipment)
        shipment = Shipment.new
        shipment.id = jsonShipment["id"];
        shipment.origin_lat = jsonShipment["origin_lat"]
        shipment.origin_lng = jsonShipment["origin_lng"]
        shipment.destiny_lat = jsonShipment["destiny_lat"]
        shipment.destiny_lng = jsonShipment["destiny_lng"]
        shipment.sender_id = jsonShipment["sender_id"]
        shipment.receiver_id = jsonShipment["receiver_id"]
        shipment.receiver_email = jsonShipment["receiver_email"]
        shipment.price = jsonShipment["price"]
        shipment.final_price = jsonShipment["final_price"]
        shipment.cadet_id = jsonShipment["cadet_id"]
        shipment.status = jsonShipment["status"]
        shipment.sender_pays = jsonShipment["sender_pays"]
        shipment.receiver_pays = jsonShipment["receiver_pays"]
        shipment.delivery_time = jsonShipment["delivery_time"]
        shipment.payment_method = jsonShipment["payment_method"]
        shipment.created_at = jsonShipment["created_at"]
        shipment.confirm_reception_url = jsonShipment["confirm_reception_url"]
        return shipment
    end
    
    def self.PENDING
        return 0
    end
    def self.SENT
        return 1
    end
    def self.CANCELLED
        return 2
    end    
    
    def sender
        @sender ||= User.find(sender_id)
    end
end
