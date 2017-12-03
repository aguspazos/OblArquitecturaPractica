class CreateEstimatedPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :estimated_prices do |t|
      t.integer :user_id
      t.integer :zone_price
      t.integer :weight_price

      t.timestamps
    end
  end
end
