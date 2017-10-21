class CreateCadets < ActiveRecord::Migration[5.1]
  def change
    create_table :cadets do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :document
      t.string :status
      t.boolean :available
      t.string :position

      t.timestamps
    end
  end
end
