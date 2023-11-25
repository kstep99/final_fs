class AddQuantityAvailableToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :quantity_available, :integer, default: 0
  end
end
