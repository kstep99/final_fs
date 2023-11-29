class OrdersController < ApplicationController
  before_action :authenticate_customer!, only: %i[new create]

  def new
    @customer = current_customer
    # Debugging: Log the customer details
    Rails.logger.debug "Customer details: #{@customer.inspect}"
  end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.order_date = Time.now
    @order.status_id = Status.find_by(name: "Pending").id

    ActiveRecord::Base.transaction do
      @order.save!
      add_products_to_order(@order)
      update_product_quantities
    end

    # Redirect to a success page or back to cart on failure
    redirect_to success_path, notice: 'Order was successfully created.'
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Order creation failed: #{e.message}"
    redirect_to cart_path, alert: 'Order could not be created.'
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

  #sort this out later, but the pst_hst thing has to go
  #gst_amount , now correctly applies pst+gst for correct tax amount
  #relable these to reflect the correct functionality
  def calculate_order_taxes(subtotal, province)
    gst_amount = calculate_tax(subtotal, province.gst + province.pst)
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
