class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  helper_method :current_user

  def domain 
    @domain = "https://enviosya-aguspazos.c9users.io/"
  end
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def check_admin
    return unless  @admin.blank?
    puts @admin.blank?
    redirect_to "/admin" 
  end
  
  def check_user
    return unless  @user.blank?
    puts @user.blank?
    redirect_to "/" 
  end
    
end

