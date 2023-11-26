# app/controllers/concerns/cart_management.rb
module CartManagement
  extend ActiveSupport::Concern

  included do
    helper_method :calculate_total_price
  end

  # Adds a product to the cart
  def add_to_cart
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    # Validation for product existence and quantity
    product = Product.find_by(id: product_id)
    unless product && quantity > 0
      redirect_to products_path, alert: 'Invalid product or quantity.'
      return
    end

    # Find existing cart item or add a new one
    current_item = session[:cart].find { |item| item["product_id"] == product_id }
    if current_item
      # Increment quantity but not beyond available stock
      current_item["quantity"] = [current_item["quantity"] + quantity, product.quantity_available].min
    else
      # Add new item to cart
      session[:cart] << { "product_id" => product_id, "quantity" => [quantity, product.quantity_available].min }
    end

    redirect_to cart_path, notice: 'Product added to cart!'
  end

  # Removes a product from the cart
  def remove_from_cart
    product_id = params[:product_id]

    # Remove the item from the cart
    session[:cart].delete_if { |item| item["product_id"] == product_id }

    redirect_to cart_path, notice: 'Product removed from cart.'
  end

  # Updates the quantity of a specific item in the cart
  def update_cart_item
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    # Fetch the product based on the product_id
    product = Product.find_by(id: product_id)

    # Ensure the product exists and the desired quantity is valid and available
    if product.nil? || quantity <= 0 || quantity > product.quantity_available
      redirect_to cart_path, alert: 'Invalid product or quantity.'
      return
    end

    # Find the cart item and update its quantity
    current_item = session[:cart].find { |item| item["product_id"] == product_id }
    if current_item
      current_item["quantity"] = quantity
    end

    redirect_to cart_path, notice: 'Cart updated.'
  end

  # Calculates the total price of items in the cart
  private

  def calculate_total_price
    session[:cart].sum do |item|
      product = Product.find(item["product_id"])
      product.price * item["quantity"]
    end
  end
end
