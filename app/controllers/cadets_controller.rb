class CadetsController < ApplicationController
  before_action :set_cadet, only: [:show, :edit, :update, :destroy]
  
  # GET /cadets
  # GET /cadets.json
  def index
    if current_cadet == nil
      redirect_to '/cadet-login'
    else
      @cadet = current_cadet
      @pendingShipments = Shipment.where(cadet_id: @cadet.id).where(status: Shipment.PENDING)
      @sentShipments = Shipment.where(status: Shipment.SENT)
      
    end
  end

  # GET /cadets/1
  # GET /cadets/1.json
  def show
  end

  # GET /cadets/new
  def new
    STDERR.puts("Hi there1")
    @cadet = Cadet.new
  end

  # GET /cadets/1/edit
  def edit
  end

  # POST /cadets
  # POST /cadets.json
  def create
    begin
      @cadet = Cadet.new(cadet_params)
      STDERR.puts("Hi there2")
      @cadet.status = Cadet.PENDING
      STDERR.puts("Hi there3")
      respond_to do |format|
            STDERR.puts("Hi there4")
        cadet = Cadet.find_by(email: params[:cadet][:email].downcase)
            STDERR.puts("Hi there5")
  
        if(cadet.blank?)
              STDERR.puts("Hi there6")
  
          if @cadet.save
                        STDERR.puts("Hi there7")
            format.html { redirect_to @cadet, notice: 'Cadet was successfully created.' }
            format.json { render :show, status: :created, location: @cadet }
          else
                                  STDERR.puts("Hi there8")
  
            format.html { render :new }
            format.json { render json: @cadet.errors, status: :unprocessable_entity }
          end
        else
          @cadet.errors.add(:base,"Ya existe un cadete con ese email")
          format.html { render :new }
          format.json { render json: @cadet.errors, status: :unprocessable_entity }
        end
      end
        # do something dodgy
      rescue ActiveRecord::RecordNotFound
                                  STDERR.puts("Hi there9")
      rescue ActiveRecord::ActiveRecordError
                                  STDERR.puts("Hi there10")
      rescue # StandardError
                                  STDERR.puts("Hi there11")
      rescue Exception => e
      
                                  STDERR.puts("Hi there12" + e.message)
        raise
    end
  end

  # PATCH/PUT /cadets/1
  # PATCH/PUT /cadets/1.json
  def update
    respond_to do |format|
      if @cadet.update(cadet_params)
        format.html { redirect_to @cadet, notice: 'Cadet was successfully updated.' }
        format.json { render :show, status: :ok, location: @cadet }
      else
        format.html { render :edit }
        format.json { render json: @cadet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cadets/1
  # DELETE /cadets/1.json
  def destroy
    @cadet.destroy
    respond_to do |format|
      format.html { redirect_to cadets_url, notice: 'Cadet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cadet
      @cadet = Cadet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cadet_params
      params.require(:cadet).permit(:first_name, :last_name, :email, :password, :document, :status, :available, :position,:avatar,:license,:vehicle_documentation)
    end
end
