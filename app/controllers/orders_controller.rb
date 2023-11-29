class OrdersController < ApplicationController
  before_action :authenticate_customer!, only: %i[new create]

  SHIPPING_COSTS = {
    'purolator' => 10.0,
    'canada_post' => 8.0,
    'dhl' => 12.0
  }.freeze

  def new
    @customer = current_customer
    @order = Order.new  # Instantiate a new Order object for the form
    Rails.logger.debug "Customer details: #{@customer.inspect}"
  end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.order_date = Time.now
    @order.status_id = Status.find_by(name: "Pending").id

    # Calculate subtotal and tax
    subtotal = calculate_cart_subtotal
    tax_amount, _ = calculate_order_taxes(subtotal, Province.find(params[:order][:province_id]))

    # Determine the shipping cost
    shipping_option = params[:order][:shipping_option]
    shipping_cost = determine_shipping_cost(shipping_option)

    # Set the total price
    @order.total_price = subtotal + tax_amount + shipping_cost

    ActiveRecord::Base.transaction do
      @order.save!
      add_products_to_order(@order)
      update_product_quantities
    end

  # Redirect to the profile page after successful order creation
  redirect_to profile_path, notice: 'Order was successfully created.'
rescue ActiveRecord::RecordInvalid => e
  Rails.logger.error "Order creation failed: #{e.message}"
  redirect_to cart_path, alert: 'Order could not be created.'
end

  private

  def order_params
    params.require(:order).permit(:total_price, :customer_id, :status_id)
  end

  def determine_shipping_cost(shipping_option)
    SHIPPING_COSTS[shipping_option] || 0
  end

  def determine_shipping_cost(shipping_option)
    SHIPPING_COSTS[shipping_option] || 0
  end

  def calculate_order_taxes(subtotal, province)
    gst_amount = calculate_tax(subtotal, province.gst)
    pst_or_hst_amount = province.hst.present? ? calculate_tax(subtotal, province.hst) : calculate_tax(subtotal, province.pst)

    total_tax = gst_amount + pst_or_hst_amount
    [total_tax, subtotal + total_tax]
  end

  def calculate_cart_subtotal
    subtotal = session[:cart].sum do |item|
      product = Product.find(item['product_id'])
      product.price * item['quantity']
    end
    subtotal
  end

  def calculate_tax(subtotal, tax_rate)
    tax_rate.present? ? subtotal * (tax_rate / 100.0) : 0
  end

  def add_products_to_order(order)
    session[:cart].each do |item|
      product = Product.find(item['product_id'])
      order.order_products.create!(
        quantity: item['quantity'],
        price: product.price,
        subtotal: product.price * item['quantity'],
        product_id: product.id
      )
    end
  end

  def update_product_quantities
    session[:cart].each do |item|
      product = Product.find(item['product_id'])
      product.update(quantity_available: product.quantity_available - item['quantity'])
    end
  end

  def order_params
    params.require(:order).permit(:customer_id, :status_id, :total_price,
                                  shipping_address_attributes: [:address, :city, :postal_code, :province_id])
  end
end
