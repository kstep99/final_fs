class Product < ApplicationRecord
  # Existing relationships and validations
  belongs_to :category
  has_many_attached :images
  validates :quantity_available, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  # Method to return the price in cents for Stripe
  def price_in_cents
    (price * 100).to_i
  end

  # Method to return the URL of the main product image (assuming Active Storage)
  # Adjust this method according to how you've set up image attachments
  def main_image_url
    images.attached? ? Rails.application.routes.url_helpers.url_for(images.first) : nil
  end

  # Method to control which attributes are searchable via Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[name description price category_id] # Add other attributes you want searchable
  end
end
