class Admin < ApplicationRecord
    def authenticate(password)
        return self.password == password
    end
end
