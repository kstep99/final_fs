# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  def index
    @products = if params[:category_id].present?
                  Product.where(category_id: params[:category_id])
                         .with_attached_images
                         .page(params[:page]) # Kaminari's page method
                else
                  Product.with_attached_images.page(params[:page]) # Paginate all products
                end
  end

  def show
    @product = Product.find(params[:id])
  end
end
