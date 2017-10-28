class Cadet < ApplicationRecord
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  has_attached_file :license, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :license, content_type: /\Aimage\/.*\z/
  has_attached_file :vehicle_documentation
  validates_attachment_content_type :vehicle_documentation, content_type: "application/pdf"
    def authenticate(password)
        return self.password == password
    end
    
end

