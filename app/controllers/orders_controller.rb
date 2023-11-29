class OrdersController < ApplicationController
  before_action :authenticate_customer!, only: %i[new create]

  def new
    @customer = current_customer
    # Debugging: Log the customer details
    Rails.logger.debug "Customer details: #{@customer.inspect}"
  end

  def calculate_taxes
    province_id = params[:province_id]
    province = Province.find(province_id)

    # Debugging: Log province details
    Rails.logger.debug "Province details: #{province.inspect}"

    subtotal = calculate_cart_subtotal
    tax_amount, total_price = calculate_order_taxes(subtotal, province)

    # Debugging: Log the tax and total price
    Rails.logger.debug "Tax amount: #{tax_amount}, Total price: #{total_price}"

    render json: { tax_amount: tax_amount, total_price: total_price }
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Province not found: #{e.message}"
    render json: { error: 'Province not found' }, status: :not_found
  end

  private

  def calculate_order_taxes(subtotal, province)
    gst_amount = calculate_tax(subtotal, province.gst)
    pst_or_hst_amount = province.hst.present? ? calculate_tax(subtotal, province.hst) : calculate_tax(subtotal, province.pst)

    total_tax = gst_amount + pst_or_hst_amount
    total_price = subtotal + total_tax

    # Debugging: Log the tax breakdown
    Rails.logger.debug "GST amount: #{gst_amount}, PST or HST amount: #{pst_or_hst_amount}, Total tax: #{total_tax}, Total price: #{total_price}"

    [total_tax, total_price]
  end

  def calculate_cart_subtotal
    subtotal = session[:cart].sum do |item|
      product = Product.find(item['product_id'])
      product.price * item['quantity']
    end

    # Debugging: Log the subtotal
    Rails.logger.debug "Calculated cart subtotal: #{subtotal}"

    subtotal
  end

  def calculate_tax(subtotal, tax_rate)
    tax = tax_rate.present? ? subtotal * (tax_rate / 100.0) : 0

    # Debugging: Log the tax calculation
    Rails.logger.debug "Calculated tax: #{tax} for rate: #{tax_rate}"

    tax
  end
end
