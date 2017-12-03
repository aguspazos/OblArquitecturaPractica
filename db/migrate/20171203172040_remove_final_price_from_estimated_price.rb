class RemoveFinalPriceFromEstimatedPrice < ActiveRecord::Migration[5.1]
  def change
    remove_column :estimated_prices, :final_price, :boolean
  end
end
