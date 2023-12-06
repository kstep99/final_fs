class RemovePaidAtFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :paid_at, :datetime
  end
end