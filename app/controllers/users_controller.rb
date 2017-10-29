class UsersController < ApplicationController
  
  require 'ci_uy'
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only:[:edit,:update]
    skip_before_action :verify_authenticity_token, :only => [:search]

  def main
    if current_user== nil
      redirect_to '/login'
    end
  end
  
  def create_shipment
    if current_user== nil
      redirect_to '/login'
    end
  end
  
  def invite
    if(current_user==nil)
      redirect_to '/login'
    end
  end
  
  def send_invite
    
    MailerHelperMailer.send_invite(current_user,params[:user][:email]).deliver!
    redirect_to '/users/invite'
  end
  
  def search 
    if params[:receiverEmail]
      @user = User.search_by_email(params[:receiverEmail])
    else
      @user = "la "
    end
    respond_to do |format|  ## Add this
      format.json { render json: @user.to_json, status: :ok}
      format.html 
    end

  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    
    if(params.has_key?(:existingUser))
      existingUser = User.find(params[:existingUser])
      if(existingUser != nil)
        @existingUser = existingUser
      end
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
        user = User.find_by(email: params[:user][:email].downcase)
        if(user.blank?)
          @user.email = @user.email.downcase
          if @user.save
            puts params[:user]
            if (params.has_key?(:inviterId))
              UserDiscount.createDiscount(params[:inviterId])
              UserDiscount.createDiscount(@user.id)
            end
          
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @user }
          else
            if(params[:inviterId])
              format.html { render :new, :existingUser => params[:inviterId] if params.has_key?(:inviterId) }
            else
              format.html { render :new }
            end
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        else
          @user.errors.add(:base,"Ya existe un usuario con ese email")
            if(params[:inviterId])
              format.html { render :new, :existingUser => params[:inviterId] if params.has_key?(:inviterId) }
            else
              format.html { render :new }
            end
            format.json { render json: @user.errors, status: :unprocessable_entity }
        end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      
      params.require(:user).permit(:name, :lastName, :email, :document, :image,:avatar,:password)
    end
  
end
