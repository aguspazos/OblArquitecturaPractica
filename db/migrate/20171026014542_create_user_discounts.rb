class CreateUserDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :user_discounts do |t|
      t.integer :user_id
      t.boolean :used

      t.timestamps
    end
  end
end
