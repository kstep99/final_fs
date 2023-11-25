class AddTaxRatesToProvinces < ActiveRecord::Migration[7.0]
  def change
    change_column :provinces, :hst, :decimal, precision: 5, scale: 4
    change_column :provinces, :gst, :decimal, precision: 5, scale: 4
    change_column :provinces, :pst, :decimal, precision: 5, scale: 4
  end
end