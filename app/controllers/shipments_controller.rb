require 'rest-client'
require 'json'
require 'geokit'
include ShipmentsHelper

class ShipmentsController < ApplicationController
  before_action :set_shipment, only: [:show, :edit, :update, :destroy]
  before_action :check_cadet, only:[:show]
  skip_before_action :verify_authenticity_token, :only => [:calculate_price, :get_cost]
  include ShipmentsHelper
  

  def create_shipment
    if current_user== nil
      redirect_to '/login'
    end
  end
  
  def confirm
  end

  # GET /shipments
  # GET /shipments.json
   def index
    # redirect_to '/cadets'
      shipments = getShipmentsEstimatedPrice
      puts "sabelo"
      puts shipments
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
                  puts "EMPEZAMOS ACÁ"
                zone_price = ApplicationController.helpers.calc_zone_price origin_area, destiny_area
                @shipment.final_price = true
                @shipment.price = zone_price + 20 * 50
                puts "CHETEANDO "+@shipment.price.to_s
                ApplicationController.helpers.set_discount @shipment
                puts "FIN" + @shipment.price.to_s
                      updateShipment @shipment

              else
                "no areas"
              end
              
            end
          end
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
  # GET /shipments/1
  # GET /shipments/1.json
  def show
  end

  # GET /shipments/new
  def new
    if current_user== nil
      redirect_to '/login'
    else
      @shipment = Shipment.new
    end
  end

  # GET /shipments/1/edit
  # def edit
  # end


  # POST /shipments
  # POST /shipments.json
  def create
    if current_user == nil
      redirect_to '/login'
    else
      @shipment = Shipment.new(origin_lat: params[:origin_lat], origin_lng: params[:origin_lng], destiny_lat: params[:destiny_lat], destiny_lng: params[:destiny_lng], sender_id: params[:sender_id], receiver_id:"", receiver_email: params[:shipment][:receiver_email], price: params[:price], final_price: params[:final_price], cadet_id:0, status: Shipment.PENDING, sender_pays: params[:shipment][:sender_pays], receiver_pays: params[:shipment][:receiver_pays], delivery_time: "", payment_method: params[:shipment][:payment_method])
      cadet = Cadet.getNearest(@shipment.origin_lat,@shipment.origin_lng)
  
      respond_to do |format|
        if(cadet.blank?)
          @shipment.errors.add(:base, "No contamos con ningún cadete disponible, intente en unos minutos")
          format.html { render :new }
          format.json { render json: @shipment.errors, status: :unprocessable_entity }
        else
          @shipment.cadet_id = cadet.id
          set_receiver
          set_discount @shipment
          if(@shipment.final_price == false || @shipment.final_price == 0)
            
            MailerHelperMailer.send_estimated_price(@shipment).deliver!
          end
          url = URI.parse(SHIPMENTS_PATH+ '/shipments')
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
        
          params[:cadet_id] = @shipment.cadet_id
          params[:final_price] = @shipment.final_price
          params[:receiver_id] = @shipment.receiver_id
          response = postRequest(SHIPMENTS_PATH+ '/shipments',params)
          
          if(response != nil)
            if response["status"] == "ok"
              format.html { redirect_to "/users/main", notice: 'Shipment was successfully created.' }
              format.json { render :show, status: :created, location: @shipment }
            else
              errorMessage = response["errorMessage"]
               @shipment.errors.add(:base, errorMessage)
              format.html { render :new }
              format.json { render json: @shipment.errors, status: :unprocessable_entity }
            end
          else
            format.html { render :new }
            format.json { render json: @shipment.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end
  
  def calculate_price
    if params[:origin_lat] && params[:origin_lng] && params[:destiny_lat] && params[:destiny_lng]
      alive = ping_server 
      if alive
        areas = get_areas
        origin_area = get_area_for_point params[:origin_lat], params[:origin_lng], areas
        destiny_area = get_area_for_point params[:destiny_lat], params[:destiny_lng], areas
        if origin_area != false && destiny_area != false
          zone_price = calc_zone_price origin_area, destiny_area
          #cost_per_kilogram = get_cost  
          msg = {:status => "ok", :price => zone_price , :origin_area => origin_area['polygon'], :destiny_area => destiny_area['polygon']}    
        else
          estimated_zone_price = 40
          msg = {:status => "ok", :price => estimated_zone_price , :origin_area => [], :destiny_area => []}    
        end
      else
        msg = {:status => "error", :errorMessage => "Service not available"}
      end
    else 
      msg = {:status => "error", :errorMessage => "Invalid data"}
    end
    respond_to do |format|
      format.json { render json: msg, status: :ok}
      format.html 
    end
  end
  
  def confirm
    
    set_shipment
    respond_to do |format|
      if(@shipment)
        if(params[:shipment] && params[:shipment][:confirm_reception])
          
          @shipment.status = Shipment.SENT
          @shipment.delivery_time = DateTime.now
          @shipment.confirm_reception = params[:shipment][:confirm_reception]
          if(@shipment.final_price == false || @shipment.final_price ==0)
            alive = ping_server 
            if alive
              areas = get_areas
              origin_area = get_area_for_point @shipment.origin_lat, @shipment.origin_lng, areas
              destiny_area = get_area_for_point @shipment.destiny_lat, @shipment.destiny_lng, areas
              if origin_area != false && destiny_area != false
                zone_price = calc_zone_price origin_area, destiny_area
                @shipment.final_price = zone_price
                @shipment.price = zone_price
                #cost_per_kilogram = get_cost  
              else
                #TODO:// ADD TO RECALCULATE QUEUE
                estimated_zone_price = 42
                @shipment.final_price = estimated_zone_price
                @shipment.price = estimated_zone_price
              end
            else
              #TODO:// ADD TO RECALCULATE QUEUE
              estimated_zone_price = 42
              @shipment.final_price = estimated_zone_price
              @shipment.price = estimated_zone_price
            end
            set_discount @shipment
          end
          MailerHelperMailer.send_price(@shipment).deliver!
          shipmentConfirmed = confirm_shipment
          if shipmentConfirmed == "ok"
            format.html{redirect_to '/cadets'}
          else
            puts shipmentConfirmed
              @shipment.errors.add(:base,shipmentConfirmed)
              format.html { render :show,location: @shipment }
              format.json { render json: @shipment.errors, status: :unprocessable_entity }
          end
        else
          @shipment.errors.add(:base, "Debe ingresar el comprobante de firma")
          format.html { render :show,location: @shipment }
          format.json { render json: @shipment.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  def confirm_shipment
    putParams = {}
    putParams[:final_price] = @shipment.final_price
    putParams[:price] = @shipment.price
    putParams[:id] = @shipment.id
    shipmentWithImage = Shipment.new
    shipmentWithImage.confirm_reception = @shipment.confirm_reception
    shipmentWithImage.save
    putParams[:confirm_reception_url] = shipmentWithImage.confirm_reception.url(:medium)

    parsedResponse = postRequest(SHIPMENTS_PATH+ '/shipments/confirm',putParams)
      if response != nil
          if parsedResponse["status"] == "ok"
            return "ok"
          else
            return parsedResponse["errorMessage"]
          end
      else
        return "Error inesperado, verifique su conexión a internet"
        
      end      
  end


  def get_cost
    alive = ping_server 
      if alive
        cost = get_cost_per_kilo
        if cost!= false
          msg = {:status => "ok", :cost => cost }
        else
          estimated_cost = 50
          msg = {:status => "ok", :cost => estimated_cost, :estimated => "true" }  
        end
      else
        msg = {:status => "error", :errorMessage => "Service not available"}  
      end
    respond_to do |format|
      format.json { render json: msg, status: :ok}
      format.html 
    end
  end

  # PATCH/PUT /shipments/1
  # PATCH/PUT /shipments/1.json
  # def update
  #   respond_to do |format|
  #     if @shipment.update(shipment_params)
  #       format.html { redirect_to @shipment, notice: 'Shipment was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @shipment }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @shipment.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /shipments/1
  # DELETE /shipments/1.json
  # def destroy
  #   @shipment.destroy
  #   respond_to do |format|
  #     format.html { redirect_to shipments_url, notice: 'Shipment was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shipment
      if(params[:id])
        parsedResponse = getRequest(SHIPMENTS_PATH+'/shipments/'+params[:id])
          if(parsedResponse != nil && parsedResponse["status"] == "ok")
            @shipment = Shipment.fromJson(parsedResponse["shipment"])
          else
            return nil
          end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shipment_params
      params.require(:shipment).permit(:origin_lat, :origin_lng, :destiny_lat, :destiny_lng, :sender_id, :receiver_id, :receiver_email, :price, :final_price, :cadet_id, :status, :sender_pays, :receiver_pays, :delivery_time, :payment_method,:confirm_reception)
    end
end
