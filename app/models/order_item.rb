class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  # Additional attributes
  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }

  # You might want to add a method to calculate the total price of this order item
  def total_price
    quantity * unit_price
  end

  # Callback to set unit_price from the associated product
  before_save :set_unit_price

  private

  def set_unit_price
    self.unit_price ||= product.price
  end
end
