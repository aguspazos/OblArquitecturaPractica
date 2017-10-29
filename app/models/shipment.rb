class Shipment < ApplicationRecord

    def self.PENDING
        return 0
    end
    def self.SENT
        return 1
    end
    def self.CANCELLED
        return 2
    end    
    
    def sender
        @sender ||= User.find(sender_id)
    end
end
