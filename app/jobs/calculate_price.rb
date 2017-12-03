class CalculatePrice < ApplicationJob
    queue_as :default
    
  SHIPMENTS_PATH = "https://enviosya-shipment-aguspazos.c9users.io"
    
    def perform(*args)
        puts "running"
        
        shipments = getShipmentsEstimatedPrice
        puts "pasa"
        shipments.each do |shipment|
            @shipment = shipment
            alive = false
            puts "nomore"
             alive = ApplicationController.helpers.ping_server
             puts "algo"
            if alive
                puts "alive"
              areas = ApplicationController.helpers.get_areas
              puts "areas"
              origin_area = ApplicationController.helpers.get_area_for_point @shipment.origin_lat, @shipment.origin_lng, areas
              puts "origin"
              destiny_area = ApplicationController.helpers.get_area_for_point @shipment.destiny_lat, @shipment.destiny_lng, areas
              puts "destiny"
              if origin_area != false && destiny_area != false
                  puts "SABELO"
                zone_price = ApplicationController.helpers.calc_zone_price origin_area, destiny_area
                @shipment.final_price = true
                puts zone_price
                @shipment.price = zone_price + 20 * 50
                ApplicationController.helpers.set_discount @shipment
                updateShipment @shipment
                
              else
                puts "no areas"
              end
              
            end
         end
    end
    
    def updateShipment(shipment)
        puts "UPDATE"
     putParams = {}
        putParams[:final_price] = shipment.final_price ? 1 : 0
        putParams[:price] = shipment.price
        putParams[:id] = shipment.id
        parsedResponse = ApplicationController.helpers.postRequest(SHIPMENTS_PATH+ '/shipments/updatePrice',putParams)
        if  parsedResponse != nil && parsedResponse["status"] == "ok"
            MailerHelperMailer.send_price shipment
        end
    end
    
    def getShipmentsEstimatedPrice
        puts "entra"
         parsedResponse = ApplicationController.helpers.getRequest(SHIPMENTS_PATH+'/shipments/getAll/estimated')
        if(parsedResponse != nil && parsedResponse["status"] == "ok")
            puts "LA CONCHA DE LA LORA GUAGUAGUA"
          shipments = Shipment.allFromJson(parsedResponse["shipments"])
          return shipments
        else
          return []
        end
    end
end