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
     redirect_to '/cadets'
   end
   
#     def updateShipment(shipment)
# putParams = {}
#     putParams[:final_price] = shipment.final_price ? 1 : 0
#     putParams[:price] = shipment.price
#     putParams[:id] = shipment.id
#         parsedResponse = postRequest(SHIPMENTS_PATH+ '/shipments/updatePrice',putParams)
#     end

# def getShipmentsEstimatedPrice
#         parsedResponse = ApplicationController.helpers.getRequest(SHIPMENTS_PATH+'/shipments/getAll/estimated')
#         if(parsedResponse != nil && parsedResponse["status"] == "ok")
#           shipments = Shipment.allFromJson(parsedResponse["shipments"])
#           return shipments
#         else
#           return []
#         end
#     end
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

  # POST /shipments
  # POST /shipments.json
  def create
    if current_user == nil
      redirect_to '/login'
    else
      puts "Algo bien"
      estimated_price = EstimatedPrice.where(user_id: params[:sender_id]).first
      puts "algo mal"
      if estimated_price
        estimated_weight_price = estimated_price.weight_price
        estimated_zone_price = estimated_price.zone_price
        price = estimated_weight_price * params[:shipment][:weight].to_i + estimated_zone_price
        final_zone_price = estimated_price.final_zone_price
        final_weight_price = estimated_price.final_weight_price
        final_price = final_zone_price && final_weight_price
        @shipment = Shipment.new(origin_lat: params[:origin_lat], origin_lng: params[:origin_lng], destiny_lat: params[:destiny_lat], destiny_lng: params[:destiny_lng], sender_id: params[:sender_id], receiver_id:"", receiver_email: params[:shipment][:receiver_email], price: price, final_price: final_price, cadet_id:0, status: Shipment.PENDING, sender_pays: params[:shipment][:sender_pays], receiver_pays: params[:shipment][:receiver_pays], delivery_time: "", payment_method: params[:shipment][:payment_method], weight: params[:shipment][:weight])
        cadet = Cadet.getNearest(@shipment.origin_lat,@shipment.origin_lng)
        respond_to do |format|
          if(cadet.blank?)
            @shipment.errors.add(:base, "We don´t have any available cadets, try in a few minutes")
            format.html { render :new }
            format.json { render json: @shipment.errors, status: :unprocessable_entity }
          else
            @shipment.cadet_id = cadet.id
            set_receiver
            set_discount @shipment
            if(@shipment.final_price == false || @shipment.final_price == 0)
              
               MailerHelperMailer.send_estimated_price(@shipment).deliver!
            end
          
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
  end
  
  def calculate_zone_price
    if params[:origin_lat] && params[:origin_lng] && params[:destiny_lat] && params[:destiny_lng] && params[:user_id]
      alive = ping_server 
      if alive
        areas = get_areas
        origin_area = get_area_for_point params[:origin_lat], params[:origin_lng], areas
        destiny_area = get_area_for_point params[:destiny_lat], params[:destiny_lng], areas
        if origin_area != false && destiny_area != false
          zone_price =  calc_zone_price origin_area, destiny_area
          update_estimated_zone_price(params[:user_id], zone_price)
          msg = {:status => "ok", :price => zone_price , :origin_area => origin_area['polygon'], :destiny_area => destiny_area['polygon']}    
        else
          update_estimated_zone_price(params[:user_id])
          msg = {:status => "ok", :price => 50 , :origin_area => [], :destiny_area => []}    
        end
      else
        update_estimated_price(params[:user_id]) 
        msg = {:status => "ok", :price => 50 , :origin_area => [], :destiny_area => []}    
      end
    else 
      msg = {:status => "error", :errorMessage => "Invalid data"}
    end
    respond_to do |format|
      format.json { render json: msg, status: :ok}
      format.html 
    end
  end
  
  def calculate_weight_price
    if params[:user_id]
      alive = ping_server 
      if alive
        cost = get_cost_per_kilo
        if cost!= false
          update_estimated_weight_price(params[:user_id], cost["cost"])
          msg = {:status => "ok", :cost => cost["cost"] }
        else
          update_estimated_weight_price(params[:user_id])
          msg = {:status => "ok", :cost => 30, :estimated => "true" }  
        end
      else
        update_estimated_weight_price(params[:user_id])
          msg = {:status => "ok", :cost => 30, :estimated => "true" }  
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
                @shipment.price = zone_price  + 10*50
                cost = get_cost_per_kilo
                if(cost != false)
                  @shipment.price = zone_price + cost["cost"] * @shipment.weight
                  @shipment.final_price = 1
                else
                  @shipment.final_price = 0
                end
                
              else
                estimated_zone_price = 50
                @shipment.final_price = 0
                @shipment.price = estimated_zone_price + 10*50
              end
            else
              estimated_zone_price = 50
              @shipment.final_price = 0
              @shipment.price = estimated_zone_price + 10*50
            end
            set_discount @shipment
          end
          MailerHelperMailer.send_price(@shipment).deliver! if @shipment.final_price != false && @shipment.final_price !=0
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
      else
         @shipment.errors.add(:base, "No encontramos ese shipment")
          format.html { render :show,location: @shipment }
          format.json { render json: @shipment.errors, status: :unprocessable_entity }
      end
      
    end
  end
  
  def confirm_shipment
    putParams = {}
    putParams[:final_price] = @shipment.final_price ? 1 : 0
    putParams[:price] = @shipment.price
    putParams[:id] = @shipment.id
    shipmentWithImage = Shipment.new
    shipmentWithImage.confirm_reception = @shipment.confirm_reception
    shipmentWithImage.save
    puts "url"+ shipmentWithImage.confirm_reception.url(:medium)
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
      params.require(:shipment).permit(:origin_lat, :origin_lng, :destiny_lat, :destiny_lng, :sender_id, :receiver_id, :receiver_email, :price, :final_price, :cadet_id, :status, :sender_pays, :receiver_pays, :delivery_time, :payment_method,:confirm_reception,:weight)
    end
end
