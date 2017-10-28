class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :lastName
      t.string :email
      t.string :document

      t.timestamps
    end
  end
  def self.up
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :image, :text
  end
end
