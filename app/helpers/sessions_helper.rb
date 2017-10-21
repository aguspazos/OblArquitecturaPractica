module SessionsHelper
    
    def cadet_log_in(cadet)
        session[:cadet_id] = cadet.id
    end
    
    def current_cadet
        @current_cadet ||= Cadet.find_by(id: session[:cadet_id])
    end
    
    def cadet_log_out
        session.delete(:cadet_id)
        @current_cadet = nil
    end
    
    def user_log_in(user)
        session[:user_id] = user.id
    end
    
    def current_user
        @current_user ||= User.find_by(id: session[:user_id])
    end
    
    def user_log_out
        session.delete(:user_id)
        @current_user = nil
    end
    
    def admin_log_in(admin)
        session[:admin_id] = admin.id
    end
    
    def current_admin
        @current_admin ||= Admin.find_by(id: session[:admin_id])
    end
    
    def admin_log_out
        session.delete(:admin_id)
        @current_user = nil
    end
    
end
