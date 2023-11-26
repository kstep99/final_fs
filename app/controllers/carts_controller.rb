class CartsController < ApplicationController
  include CartManagement

  def show
    @cart_items = session[:cart] || []
    @total_price = @cart_items.empty? ? 0 : calculate_total_price
  end

  def initiate_checkout
    if customer_signed_in?
      # Assuming you have an order creation path or a checkout summary page
      redirect_to new_order_path # Replace with your actual new order path
    else
      # Store the intended path for checkout to redirect after sign-in
      session[:checkout_path] = new_order_path # Replace with your actual new order path
      flash[:alert] = 'Please sign in or sign up to complete your purchase'
      redirect_to new_customer_session_path
    end
  end

  # You could use this method as a before_action filter if needed
  def store_checkout_path
    session[:checkout_path] = new_order_path # Replace with your actual new order path
  end

  private

  def calculate_total_price
    session[:cart].sum do |item|
      product = Product.find(item["product_id"])
      product.price * item["quantity"]
    end
  end
end
