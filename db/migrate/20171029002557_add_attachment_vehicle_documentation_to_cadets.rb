class AddAttachmentVehicleDocumentationToCadets < ActiveRecord::Migration[5.1]
  def self.up
    change_table :cadets do |t|
      t.attachment :vehicle_documentation
    end
  end

  def self.down
    remove_attachment :cadets, :vehicle_documentation
  end
end
