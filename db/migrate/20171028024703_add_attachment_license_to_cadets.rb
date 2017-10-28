class AddAttachmentLicenseToCadets < ActiveRecord::Migration[5.1]
  def self.up
    change_table :cadets do |t|
      t.attachment :license
    end
  end

  def self.down
    remove_attachment :cadets, :license
  end
end
