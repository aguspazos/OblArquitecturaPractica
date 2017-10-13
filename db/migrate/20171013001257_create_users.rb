class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :lastName
      t.string :email
      t.string :document
      t.string :image

      t.timestamps
    end
  end
end
