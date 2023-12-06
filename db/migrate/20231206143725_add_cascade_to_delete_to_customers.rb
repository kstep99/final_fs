class AddCascadeToDeleteToCustomers < ActiveRecord::Migration[7.0]
  def change
    # Remove the existing foreign key
    remove_foreign_key :customers, :provinces

    # Add the foreign key back with the cascade delete option
    add_foreign_key :customers, :provinces, on_delete: :cascade
  end
end
