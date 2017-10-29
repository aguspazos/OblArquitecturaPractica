class AdminsController < ApplicationController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]
   before_action :check_admin, only: [:show,:edit,:update,:destroy,:accept_cadet,:reject_cadet]
  


  # GET /admins/1
  # GET /admins/1.json
  def show
  end

  # GET /admins/new
  def new
    @admin = Admin.new
  end

  # GET /admins/1/edit
  def edit
  end
  def index
    if(current_admin == nil)
      render 'sessions/new_admin'
    else
       @cadets = Cadet.where(status: Cadet.PENDING)
    end
  end
  

  

  # POST /admins
  # POST /admins.json
  def create
    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        format.html { redirect_to @admin, notice: 'Admin was successfully created.' }
        format.json { render :show, status: :created, location: @admin }
      else
        format.html { render :new }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admins/1
  # PATCH/PUT /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to @admin, notice: 'Admin was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.json
  def destroy
    @admin.destroy
    respond_to do |format|
      format.html { redirect_to admins_url, notice: 'Admin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def accept_cadet
    if(params[:cadet_id])
      cadet = Cadet.find(params[:cadet_id])
       respond_to do |format|
        if(cadet.blank?)
               format.html { redirect_to admins_url, notice: 'Cadet not Accepted' }
              format.json { head :no_content }
        else
          cadet.status = Cadet.ACCEPTED
          if(cadet.save)
            format.html { redirect_to admins_url, notice: 'Cadet Accepted' }
            format.json { head :no_content }
          else
               format.html { redirect_to admins_url, notice: 'Cadet not Accepted' }
              format.json { head :no_content }
          end
        end
      end
    end
  end  
  
  def reject_cadet
    if(params[:cadet_id])
      cadet = Cadet.find(params[:cadet_id])
       respond_to do |format|
        if(cadet.blank?)
               format.html { redirect_to admins_url, notice: 'Cadet not Rejected' }
              format.json { head :no_content }
        else
          cadet.status = Cadet.REJECTED
          if(cadet.save)
            format.html { redirect_to admins_url, notice: 'Cadet Rejected' }
            format.json { head :no_content }
          else
               format.html { redirect_to admins_url, notice: 'Cadet not Rejected' }
              format.json { head :no_content }
          end
        end
      end
    end
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_params
      params.require(:admin).permit(:name, :email, :password)
    end
end
