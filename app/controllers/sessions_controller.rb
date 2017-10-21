class SessionsController < ApplicationController
  
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
        
      render 'new_cadet'
    end
  end

  def destroy_cadet
    cadet_log_out
    render 'new_cadet'
  end
  
end
