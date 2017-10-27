class SessionsController < ApplicationController
  
  def create
    user = User.from_omniauth(Env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
  
  def new_cadet
    if current_cadet!= nil
      redirect_to current_cadet
    end
  end
  
  def create_cadet
    cadet = Cadet.find_by(email: params[:session][:email].downcase)
    if cadet && cadet.authenticate(params[:session][:password])
      cadet_log_in cadet
      redirect_to cadet
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new_cadet'
    end
  end

  def destroy_cadet
    cadet_log_out
    render 'new_cadet'
  end
  
  def new_user
    if current_user!= nil
      redirect_to current_user
    end
  end
  
  def create_user
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      user_log_in user
      redirect_to '/users/main'
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new_user'
    end
  end

  def destroy_user
    user_log_out
    render 'new_user'
  end
  
  def new_admin
    if current_admin!= nil
      redirect_to current_admin
    end
  end
  
  def create_admin
    admin = Admin.find_by(email: params[:session][:email].downcase)
    if admin && admin.authenticate(params[:session][:password])
      admin_log_in admin
      redirect_to '/admin'
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new_admin'
    end
  end

  def destroy_admin
    admin_log_out
    render 'new_admin'
  end
end





