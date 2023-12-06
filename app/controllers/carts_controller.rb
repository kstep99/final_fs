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





  def update_cart_item
    product_id = params[:product_id].to_i
    new_quantity = params[:quantity].to_i

    # Update the quantity of the specified product in the cart
    update_cart(product_id, new_quantity)

    redirect_to cart_path, notice: 'Cart updated successfully.'
  end

  def remove_from_cart
    product_id = params[:product_id].to_i

    # Remove the specified product from the cart
    remove_product_from_cart(product_id)

    redirect_to cart_path, notice: 'Item removed from cart.'
  end

  private



  # You could use this method as a before_action filter if needed
  def store_checkout_path
    session[:checkout_path] = new_order_path # Replace with your actual new order path
  end

  private


  def update_cart(product_id, new_quantity)
    session[:cart].each do |item|
      if item["product_id"] == product_id
        item["quantity"] = new_quantity
        break
      end
    end
  end

  def remove_product_from_cart(product_id)
    session[:cart].delete_if { |item| item["product_id"] == product_id }
  end
end

  def calculate_total_price
    session[:cart].sum do |item|
      product = Product.find(item["product_id"])
      product.price * item["quantity"]
    end
  end

