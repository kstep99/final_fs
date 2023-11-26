class CheckoutController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_address_present, only: [:new]

  def new
    # Logic to display the invoice page
    @cart_items = session[:cart] || []
    @customer = current_customer
    # Calculate total price, taxes, etc. based on cart items and customer's province
  end

  def create
    # Logic to handle order creation and payment processing (if applicable)
    # Redirect to a confirmation page or display a confirmation message
  end

  private

  def ensure_address_present
    if current_customer.address.blank? || current_customer.city.blank? || current_customer.postal_code.blank? || current_customer.province_id.blank?
      redirect_to edit_profile_path, alert: "Please complete your address information before proceeding to checkout."
    end
  end
end
