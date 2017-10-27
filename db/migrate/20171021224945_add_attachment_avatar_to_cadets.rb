class AddAttachmentAvatarToCadets < ActiveRecord::Migration[5.1]
  def self.up
    change_table :cadets do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :cadets, :avatar
  end
end
