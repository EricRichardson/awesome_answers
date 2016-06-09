class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.text :description
      t.decimal :sale_price

      t.timestamps null: false
    end
  end
end
