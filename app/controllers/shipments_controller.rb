class ShipmentsController < ApplicationController
  before_action :set_shipment, only: [:show, :edit, :update, :destroy]
  before_action :check_cadet, only:[:show]
  
  include ShipmentsHelper
  

  def create_shipment
    if current_user== nil
      redirect_to '/login'
    end
  end

  # GET /shipments
  # GET /shipments.json
  # def index
  #   @shipments = Shipment.all
  # end

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
      params.require(:shipment).permit(:origin_lat, :origin_lng, :destiny_lat, :destiny_lng, :sender_id, :receiver_id, :receiver_email, :price, :final_price, :cadet_id, :status, :sender_pays, :receiver_pays, :delivery_time, :payment_method)
    end
end
