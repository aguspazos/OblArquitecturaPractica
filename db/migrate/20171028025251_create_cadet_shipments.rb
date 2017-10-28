class CreateCadetShipments < ActiveRecord::Migration[5.1]
  def change
    create_table :cadet_shipments do |t|
      t.references :cadet, foreign_key: true
      t.references :shipment, foreign_key: true
      t.boolean :sent

      t.timestamps
    end
  end
end
