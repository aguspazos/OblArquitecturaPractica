class AddWeightToShipment < ActiveRecord::Migration[5.1]
  def change
    add_column :shipments, :weight, :integer
  end
end
