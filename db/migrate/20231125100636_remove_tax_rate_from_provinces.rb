class RemoveTaxRateFromProvinces < ActiveRecord::Migration[7.0]
  def change
    remove_column :provinces, :tax_rate, :decimal
  end
end
