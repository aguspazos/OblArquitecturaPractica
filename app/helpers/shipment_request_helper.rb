module ShipmentRequestHelper

  SHIPMENT_REQUEST_TOKEN = "25f9e794323b453885f5181f1b624d0b"

    
    def getRequest(url)
        puts "mmm?  "
         response = Net::HTTP.get(URI.parse(url + "?token=" + SHIPMENT_REQUEST_TOKEN))
      begin
      puts url
        parsedResponse = JSON.parse response
        puts parsedResponse
        return parsedResponse
      rescue JSON::ParserError
        puts "ERROR PARSING JSON in "+url
        return nil;
      end
    
    end
    
    def postRequest(url,postParams)
          uri = URI.parse(url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          postParams["token"] = ApplicationController::SHIPMENT_REQUEST_TOKEN
  
          request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
          postParams["token"] = SHIPMENT_REQUEST_TOKEN
          request.body = postParams.to_json
          response = http.request(request)
          if response.code == "200"
            begin
              parsedResponse = JSON.parse response.body

              return parsedResponse
            rescue JSON::ParserError
              puts "ERROR PARSING JSON in "+url
              return nil;
            end
          else
            return nil
          end
    end 
    
    def putRequest(url,putParams)
          uri = URI.parse(url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
        
          request = Net::HTTP::Put.new(uri.path, {'Content-Type' => 'application/json'})
          request.body = putParams.to_json
          response = http.request(request)
          return response
    end 
end