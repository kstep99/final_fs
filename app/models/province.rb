class Province < ApplicationRecord
  validates :name, presence: true
  validates :tax_rate, numericality: { greater_than_or_equal_to: 0 }

  # Define searchable attributes for Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[name tax_rate]
  end

end