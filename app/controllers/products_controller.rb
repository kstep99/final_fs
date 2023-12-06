class ProductsController < ApplicationController
  include CartManagement
  before_action :set_product, only: [:show, :destroy]
  before_action :set_user_dashboard, only: [:index]

  def index
    @products = params[:category_id].present? ? Product.where(category_id: params[:category_id]) : Product.all

    if params[:keyword].present?
      @products = @products.where('name LIKE :keyword OR description LIKE :keyword', keyword: "%#{params[:keyword]}%")
    end

    @products = @products.with_attached_images.page(params[:page]).per(10)
  end

  def show
    # @product is set by the set_product before_action
  end

  def add_to_cart
    quantity = params[:quantity].to_i
    product = Product.find_by(id: params[:product_id])

    if product.nil? || quantity <= 0 || quantity > product.quantity_available
      redirect_to product_path(product), alert: 'Invalid quantity or product not available.'
      return
    end

    session[:cart] << { "product_id" => product.id, "quantity" => quantity }
    redirect_to products_path, notice: 'Product added to cart!'
  end

  def destroy
    if @product.can_be_deleted?
      @product.destroy
      redirect_to products_path, notice: 'Product was successfully deleted.'
    else
      redirect_to products_path, alert: 'Product cannot be deleted as it is part of an existing order.'
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_user_dashboard
    if customer_signed_in?
      @customer_dashboard_info = {
        email: current_customer.email,
        recent_orders: current_customer.orders.last(5)
      }
    end
  end
end
