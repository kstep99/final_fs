class Product < ApplicationRecord
  # Add validations as necessary, for example:
  validates :quantity_available, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :category
  has_many_attached :images

  def self.ransackable_attributes(auth_object = nil)
    %w[name description price category_id] # add other attributes you want searchable
  end
end
