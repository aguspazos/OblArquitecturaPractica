class Shipment < ApplicationRecord
  has_attached_file :confirm_reception, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :confirm_reception, content_type: /\Aimage\/.*\z/

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
