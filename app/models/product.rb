class Product < ApplicationRecord
  # Relationships
  belongs_to :category
  has_many_attached :images
  has_many :order_products

  # Validations
  validates :quantity_available, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  # Method to return the price in cents for Stripe
  def price_in_cents
    (price * 100).to_i
  end

  # Method to return the URL of the main product image
  def main_image_url
    images.attached? ? Rails.application.routes.url_helpers.url_for(images.first) : nil
  end

  # Check if product can be deleted
  def can_be_deleted?
    order_products.empty?
  end

  # Searchable attributes for Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[name description price category_id]
  end
end
