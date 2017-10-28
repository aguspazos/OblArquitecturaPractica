class CadetShipment < ApplicationRecord
  belongs_to :cadet
  belongs_to :shipment
end
