class OrdersController < ApplicationController
  before_action :authenticate_customer!, only: [:new, :create]

  def new
    if customer_signed_in?
      @customer = current_customer
      # Create a new order object if needed
      @order = Order.new
    else
      redirect_to new_customer_session_path, alert: 'Please sign in to continue.'
    end
  end

  # Add other actions as needed, such as create, show, etc.

  def calculate_taxes
    province_id = params[:province_id]
    province = Province.find(province_id)

    tax_amount, total_price = calculate_order_taxes(province)

    render json: { tax_amount: tax_amount, total_price: total_price }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Province not found" }, status: :not_found
  end

  private

  def calculate_order_taxes(province)
    subtotal = session[:cart].sum do |item|
      product = Product.find(item["product_id"])
      product.price * item["quantity"]
    end

    gst = subtotal * province.gst / 100
    pst_or_hst = subtotal * (province.pst || province.hst) / 100
    total_price = subtotal + gst + pst_or_hst

    return gst + pst_or_hst, total_price
  end
end
