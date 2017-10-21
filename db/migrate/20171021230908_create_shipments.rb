class CreateShipments < ActiveRecord::Migration[5.1]
  def change
    create_table :shipments do |t|
      t.string :origin_lat
      t.string :origin_lng
      t.string :destiny_lat
      t.string :destiny_lng
      t.integer :sender_id
      t.integer :receiver_id
      t.string :receiver_email
      t.float :price
      t.boolean :final_price
      t.integer :cadet_id
      t.integer :status
      t.boolean :sender_pays
      t.boolean :receiver_pays
      t.datetime :delivery_time
      t.integer :payment_method

      t.timestamps
    end
  end
end
