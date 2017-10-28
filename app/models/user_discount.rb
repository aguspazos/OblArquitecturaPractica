class UserDiscount < ApplicationRecord
    belongs_to :user
    
    def self.createDiscount(id)
        discount = UserDiscount.new
        discount.user_id = id
        discount.used = 0
        discount.save
    end
end
