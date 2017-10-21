class Cadet < ApplicationRecord

    def authenticate(password)
        return self.password == password
    end
    
end

