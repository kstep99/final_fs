class AddCascadeToDeleteToOrders < ActiveRecord::Migration[7.0]
    def change
      # First, remove the existing foreign key
      remove_foreign_key :orders, :customers

      # Then, re-add the foreign key with on_delete: :cascade
      add_foreign_key :orders, :customers, on_delete: :cascade
    end
  end
