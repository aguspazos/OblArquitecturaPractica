class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  helper_method :current_user
  SHIPMENTS_PATH = "https://enviosya-shipment-aguspazos.c9users.io"
  SHIPMENT_REQUEST_TOKEN = "123456789"
  def domain 
    @domain = "https://enviosya-aguspazos.c9users.io/"
  end
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def check_admin
    return unless  current_admin == nil
    redirect_to "/admin" 
  end
  def check_user
    return unless  current_user == nil
    redirect_to "/" 
  end
  def check_cadet
    return unless  current_cadet == nil
    redirect_to "/cadet-login" 
  end
  
  
  def render_404
    if params[:format].present? && params[:format] != 'html'
      head status: 404
    else
     render 'application/404', status: 404
    end
  end

  def on_access_denied
    if params[:format].present? && params[:format] != 'html'
      head status: 401
    else
      render 'application/401', status: 401
    end
  end

  def on_record_not_found
    render_404
  end

  def on_routing_error
    render_404
    redirect_to "/admin" 
  end
  
  def check_user
    return unless  @user.blank?
    puts @user.blank?
    redirect_to "/" 
  end
    
end

