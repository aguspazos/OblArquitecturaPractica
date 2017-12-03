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
             alive = ApplicationController.helpers.ping_server
            if alive
                puts "alive"
              areas = ApplicationController.helpers.get_areas
              puts "areas"
              origin_area = ApplicationController.helpers.get_area_for_point @shipment.origin_lat, @shipment.origin_lng, areas
              puts "origin"
              destiny_area = ApplicationController.helpers.get_area_for_point @shipment.destiny_lat, @shipment.destiny_lng, areas
              puts "destiny"
              if origin_area != false && destiny_area != false
                zone_price = ApplicationController.helpers.calc_zone_price origin_area,  
                cost = get_cost_per_kilo
                if(cost != false)
                  shipment.price = zone_price + cost["cost"] * shipment.weight
                  shipment.final_price = true
                    puts zone_price
                    ApplicationController.helpers.set_discount shipment
                    updateShipment shipment
                else
                    puts "No cost_per_kilo"
                end
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
         puts "response:"
        if(parsedResponse != nil && parsedResponse["status"] == "ok")
            puts "LA CONCHA DE LA LORA GUAGUAGUA"
          shipments = Shipment.allFromJson(parsedResponse["shipments"])
          return shipments
        else
          return []
        end
    end
end