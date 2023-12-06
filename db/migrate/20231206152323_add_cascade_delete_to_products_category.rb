class AddCascadeDeleteToProductsCategory < ActiveRecord::Migration[7.0]
  def change
    # Replace 'categories' and 'products' with the actual table names
    # Replace 'category_id' with the actual foreign key column if it's different
    remove_foreign_key :products, :categories
    add_foreign_key :products, :categories, column: :category_id, on_delete: :cascade
  end
end
