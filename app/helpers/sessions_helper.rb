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
    
end
