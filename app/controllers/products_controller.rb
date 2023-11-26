# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  include CartManagement
  before_action :set_user_dashboard, only: [:index]

  def index
    # Start with all products or a specific category if provided
    @products = params[:category_id].present? ? Product.where(category_id: params[:category_id]) : Product.all

    # Filter by keyword if provided
    if params[:keyword].present?
      @products = @products.where('name LIKE :keyword OR description LIKE :keyword', keyword: "%#{params[:keyword]}%")
    end

    # Apply pagination to the @products query
    @products = @products.with_attached_images.page(params[:page]).per(10) # Adjust the number per page as needed
  end


  def show
    @product = Product.find(params[:id])
  end

  def add_to_cart
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    # Fetch the product and check if it's available
    product = Product.find_by(id: product_id)
    if product.nil? || quantity <= 0 || quantity > product.quantity_available
      redirect_to product_path(product), alert: 'Invalid quantity or product not available.'
      return
    end

    # Add product to cart, logic handled in the CartManagement concern
    session[:cart] << { "product_id" => product_id, "quantity" => quantity }
    redirect_to products_path, notice: 'Product added to cart!'
  end

  private

  def set_user_dashboard
    if customer_signed_in?
      @customer_dashboard_info = {
        email: current_customer.email,
        recent_orders: current_customer.orders.last(5)
      }
    end
  end
end
