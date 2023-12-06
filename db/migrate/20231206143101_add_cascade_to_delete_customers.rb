class AddCascadeToDeleteCustomers < ActiveRecord::Migration[7.0]
  def change
    # Assuming 'orders' table has a foreign key reference to 'customers'
    remove_foreign_key :orders, :customers
    add_foreign_key :orders, :customers, on_delete: :cascade

    # Repeat for other tables referencing 'customers'
  end
end
