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

    # Continue with existing pagination
    @products = @products.with_attached_images.page(params[:page])
  end

  def show
    @product = Product.find(params[:id])
  end

  private

  # This method will set user dashboard information if the customer is signed in
  def set_user_dashboard
    if customer_signed_in?
      # Set up user dashboard information here.
      # This is just a placeholder. You will need to adapt it to your actual data structure.
      @customer_dashboard_info = {
        email: current_customer.email,
        recent_orders: current_customer.orders.last(5) # for example
        # Include any other information you want to display on the dashboard
      }
    end
  end
end
