class AddFinalZonePriceToEstimatedPrice < ActiveRecord::Migration[5.1]
  def change
    add_column :estimated_prices, :final_zone_price, :boolean
  end
end
