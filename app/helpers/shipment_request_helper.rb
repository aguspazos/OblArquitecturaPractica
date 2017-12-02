module ShipmentRequestHelper

    
    def getRequest(url)
         response = Net::HTTP.get(URI.parse(url))
      begin
        parsedResponse = JSON.parse response
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
        
          request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
          request.body = postParams.to_json
          response = http.request(request)
          return response
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