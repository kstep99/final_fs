class OrdersController < ApplicationController
  before_action :authenticate_customer!, only: %i[new create]

  def new
    # existing code
  end

  def calculate_taxes
    province_id = params[:province_id]
    province = Province.find(province_id)

    tax_amount, total_price = calculate_order_taxes(province)

    render json: { tax_amount:, total_price: }
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Province not found' }, status: :not_found
  end

  private

  def calculate_order_taxes(province)
    subtotal = calculate_cart_subtotal

    gst_amount = calculate_tax(subtotal, province.gst)
    pst_amount = calculate_tax(subtotal, province.pst)
    hst_amount = calculate_tax(subtotal, province.hst)

    total_tax = hst_amount > 0 ? hst_amount : (gst_amount + pst_amount)
    total_price = subtotal + total_tax

    [total_tax, total_price]
  end

  def calculate_cart_subtotal
    session[:cart].sum do |item|
      product = Product.find(item['product_id'])
      product.price * item['quantity']
    end
  end

  def calculate_tax(subtotal, tax_rate)
    tax_rate.present? ? subtotal * (tax_rate / 100.0) : 0
  end
end
