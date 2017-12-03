class EstimatedPrice < ApplicationRecord
    def to_s
        "User id: #{self.user_id} Zone price: #{self.zone_price} Weight price: #{self.weight_price}"
    end
end
