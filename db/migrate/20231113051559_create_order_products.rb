class CreateOrderProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :order_products do |t|
      t.integer :quantity, null: false, default: 1
      t.decimal :price, precision: 10, scale: 2, null: false
      t.decimal :subtotal, precision: 12, scale: 2, null: false
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end