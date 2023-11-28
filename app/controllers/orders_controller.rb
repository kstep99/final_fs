class OrdersController < ApplicationController
  before_action :authenticate_customer!, only: %i[new create]

  def new
    @customer = current_customer

  end

  def calculate_taxes
    province_id = params[:province_id]
    province = Province.find(province_id)

    subtotal = calculate_cart_subtotal
    tax_amount, total_price = calculate_order_taxes(subtotal, province)

    render json: { tax_amount: tax_amount, total_price: total_price }
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Province not found' }, status: :not_found
  end

  private

  def calculate_order_taxes(subtotal, province)
    gst_amount = calculate_tax(subtotal, province.gst)
    pst_or_hst_amount = province.hst.present? ? calculate_tax(subtotal, province.hst) : calculate_tax(subtotal, province.pst)

    total_tax = gst_amount + pst_or_hst_amount
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
