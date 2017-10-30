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
      @shipment = Shipment.new(origin_lat: params[:origin_lat], origin_lng: params[:origin_lng], destiny_lat: params[:destiny_lat], destiny_lng: params[:destiny_lng], sender_id: params[:sender_id], receiver_id:"", receiver_email: params[:shipment][:receiver_email], price: params[:price], final_price: params[:price], cadet_id:0, status: Shipment.PENDING, sender_pays: params[:shipment][:sender_pays], receiver_pays: params[:shipment][:receiver_pays], delivery_time: "", payment_method: params[:shipment][:payment_method])
      cadet = Cadet.getNearest(@shipment.origin_lat,@shipment.origin_lng)
  
      respond_to do |format|
        if(cadet.blank?)
          @shipment.errors.add(:base, "No contamos con ningún cadete disponible, intente en unos minutos")
          format.html { render :new }
          format.json { render json: @shipment.errors, status: :unprocessable_entity }
        else
          @shipment.cadet_id = cadet.id
          set_receiver
          if @shipment.save
            
            format.html { redirect_to @shipment, notice: 'Shipment was successfully created.' }
            format.json { render :show, status: :created, location: @shipment }
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
    
    @shipment = Shipment.find(params[:shipment_id])
    respond_to do |format|
      if(@shipment)
        if(params[:shipment] && params[:shipment][:confirm_reception])
         @shipment.status = Shipment.SENT
          @shipment.delivery_time = DateTime.now
          @shipment.confirm_reception = params[:shipment][:confirm_reception]
          if @shipment.save
            format.html{redirect_to '/cadets'}
          else
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
      @shipment = Shipment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shipment_params
      params.require(:shipment).permit(:origin_lat, :origin_lng, :destiny_lat, :destiny_lng, :sender_id, :receiver_id, :receiver_email, :price, :final_price, :cadet_id, :status, :sender_pays, :receiver_pays, :delivery_time, :payment_method,:confirm_reception)
    end
end
