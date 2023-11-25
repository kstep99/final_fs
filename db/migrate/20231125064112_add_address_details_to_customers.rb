class AddAddressDetailsToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :address, :string
    add_column :customers, :city, :string
    add_column :customers, :postal_code, :string
    add_reference :customers, :province, null: true, foreign_key: true
  end
end
