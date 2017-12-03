class CalculatePrice < ApplicationJob
    queue_as :default
    
    def perform(*args)
        shipments = getShipmentsEstimatedPrice
        puts "sabelo"
        shipments.each do |shipment|
            puts "la hice"
            @shipment = shipment
            alive = false
             alive = ApplicationController.helpers.ping_server
            if alive
              areas = ApplicationController.helpers.get_areas
              origin_area = ApplicationController.helpers.get_area_for_point @shipment.origin_lat, @shipment.origin_lng, areas
              destiny_area = ApplicationController.helpers.get_area_for_point @shipment.destiny_lat, @shipment.destiny_lng, areas
              if origin_area != false && destiny_area != false
                zone_price = ApplicationController.helpers.calc_zone_price origin_area, destiny_area
                @shipment.final_price = true
                puts zone_price
                @shipment.price = zone_price + 20 * 50
                ApplicationController.helpers.set_discount @shipment
                updateShipment @shipment
               else
                "no areas"
              end
              
            end
          end
    end
    
    def updateShipment(shipment)
        params = []
        params["id"] = shipment.id
        params["final_price"] = shipment.final_price
        params["price"] = shipment.price
        parsedResponse = postRequest(SHIPMENTS_PATH+ '/shipments/updatePrice',putParams)
    end
    
    def getShipmentsEstimatedPrice
         parsedResponse = ApplicationController.helpers.getRequest(SHIPMENTS_PATH+'/shipments/getAllWithEstimatedPrice')
        if(parsedResponse != nil && parsedResponse["status"] == "ok")
          shipments = Shipment.allFromJson(parsedResponse["shipments"])
          return shipments
        else
          return []
        end
    end
end