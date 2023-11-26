class CartsController < ApplicationController
  include CartManagement

  def show
    @cart_items = session[:cart] || []
    @total_price = calculate_total_price # No arguments passed
  end
end
