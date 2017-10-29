class AddAttachmentConfirmReceptionToShipments < ActiveRecord::Migration[5.1]
  def self.up
    change_table :shipments do |t|
      t.attachment :confirm_reception
    end
  end

  def self.down
    remove_attachment :shipments, :confirm_reception
  end
end
