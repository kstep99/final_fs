# app/controllers/products_controller.rb
class ProductsController < ApplicationController
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
end
