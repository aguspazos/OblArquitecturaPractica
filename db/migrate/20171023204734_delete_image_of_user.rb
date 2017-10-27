class DeleteImageOfUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :table_users, :column_image
  end
end
