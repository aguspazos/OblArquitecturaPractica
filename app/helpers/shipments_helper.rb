module ShipmentsHelper

    def find_cadet_available_and_close(lat, lng)
        return 0
    end

    def get_areas
        begin
            areas = RestClient::Request.execute method: :get, url: "https://delivery-rates.mybluemix.net/areas", user: '178253', password: '5y239sa8CPpa'
            areas_json = JSON.parse(areas) 
            return parse_areas(areas_json)
        rescue RestClient::ExceptionWithResponse => err
            return []
        end
    end
    
    def get_cost_per_kilo
        begin
            cost = RestClient::Request.execute method: :get, url: "https://delivery-rates.mybluemix.net/cost", user: '178253', password: '5y239sa8CPpa'
            cost_json = JSON.parse(cost) 
            puts cost_json
            return 50
        rescue RestClient::ExceptionWithResponse => err
            return false
        end
    end
    
    def get_area_for_point(lat, lng, areas)
        areas.each do |area|
            polygon = get_polygon(area['polygon'])
            inside = point_in_polygon(lat, lng, polygon)
            if inside
                return area
                break
            end
        end
        return false
    end
    
    def calc_zone_price(area_origin, area_destiny)
        id = area_destiny['id']
        return area_origin['cost_to_areas'][id]
    end
    
    def get_cost(package_price)
        
    end
    
    def ping_server
        body = RestClient::Request.execute method: :get, url: "https://delivery-rates.mybluemix.net/", user: '178253', password: '5y239sa8CPpa'
        json_response = JSON.parse(body)
        return json_response["ok"]
    end
    
    def parse_area(area)
        area.slice!(0,10)
        area = area.chomp('))')
        area = area.split(',')
        area_array = []
        area.each do |point|
            lat_lng = point.split(' ')
            json_lat_lng = {"lat" => lat_lng[0].to_f, "lng" => lat_lng[1].to_f}
            area_array.push(json_lat_lng)
        end
        return area_array
    end
    
    def parse_areas(areas)
        parsed_areas = []
        areas.each do |area|
            parsed_area = parse_area(area['polygon'])
            id = area['id']
            cost_to_areas = area['costToAreas']
            name = area['name']
            new_area = {"id" => id, "polygon" => parsed_area, "cost_to_areas" => cost_to_areas, "name" => name}
            parsed_areas.push(new_area)
        end
        return parsed_areas
    end
    
    def point_in_polygon(lat, lng, polygon)
        point = Geokit::LatLng.new(lat,lng)
        return polygon.contains?(point)
    end
    
    def get_polygon(polygon)
        points_array = []
        polygon.each do |point|
            lat_lng = Geokit::LatLng.new(point['lat'], point['lng'])
            points_array.push(lat_lng)
        end
        return polygon = Geokit::Polygon.new(points_array)
    end

    def set_receiver
        receiver = User.where(email: @shipment.receiver_email).take
        if(receiver.blank?)
            MailerHelperMailer.send_invite(current_user,@shipment.receiver_email).deliver!
        else
            @shipment.receiver_id = receiver.id
        end

    end
    
    def set_discount
        userDiscount = UserDiscount.where(user_id: @shipment.sender_id).where(used: 0).first
        if(!userDiscount.blank?)
            if(final_price != 0)
                userDiscount.used = true
                userDiscount.save
                if(@shipment.sender_pays == true && @shipment.receiver_pays)
                    @shipment.final_price -= @shipment.final_price/4 unless final_price == 0
                    @shipment.price -= @shipment.price/4
                    
                else
                    @shipment.final_price -= @shipment.final_price/2 unless final_price == 0
                    @shipment.price -= @shipment.price/2            
                end
            end
        end
    end
end

