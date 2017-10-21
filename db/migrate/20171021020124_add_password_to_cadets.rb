class AddPasswordToCadets < ActiveRecord::Migration[5.1]
  def change
    add_column :cadets, :password, :string
  end
end
