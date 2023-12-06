class DropOrderItemsTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :order_items if table_exists?(:order_items)
  end

  def down
    # Recreate the order_items table in the down method if necessary.
    # If you don't need to recreate it, you can leave the down method empty or add a comment.
  end
end