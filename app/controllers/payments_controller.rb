class PaymentsController < ApplicationController
  before_action :authenticate_customer!

  Stripe.api_key = ENV['STRIPE_SECRET_KEY']

  SHIPPING_COSTS = {
    'purolator' => 10.0,
    'canada_post' => 8.0,
    'dhl' => 12.0
  }.freeze

# POST /payments
def create
  cart_items = session[:cart] || []

  # Calculate total price for the cart
  subtotal = calculate_cart_subtotal(cart_items)
  tax_amount = calculate_order_taxes(subtotal, current_customer.province)
  shipping_cost = determine_shipping_cost(cart_items)
  total_price = subtotal + tax_amount + shipping_cost

  line_items = cart_items.map do |item|
    product = Product.find(item['product_id'])
    {
      price_data: {
        currency: 'usd',
        product_data: {
          name: product.name,
          description: product.description
        },
        unit_amount: (product.price * 100).to_i  # Convert to cents
      },
      quantity: item['quantity']
    }
  end

  @session = Stripe::Checkout::Session.create(
    payment_method_types: ['card'],
    line_items: line_items,
    mode: 'payment',
    success_url: payments_success_url + '?session_id={CHECKOUT_SESSION_ID}',
    cancel_url: payments_cancel_url
  )

  respond_to do |format|
    format.js
  end
end


  # GET /payments/success
  def success
    session_id = params[:session_id]
    stripe_session = Stripe::Checkout::Session.retrieve(session_id)

    ActiveRecord::Base.transaction do
      order = current_customer.orders.create!(
        order_date: Time.now,
        total_price: calculate_total_price_from_cart(session[:cart]),
        status_id: Status.find_by(name: "Pending").id
      )

      create_order_products(order, session[:cart])
      update_product_quantities

      # Additional logic for post-order creation (like sending confirmation email) goes here
    end

    redirect_to profile_path, notice: 'Order was successfully created.'
  rescue Stripe::StripeError, ActiveRecord::RecordInvalid => e
    Rails.logger.error "Payment or order creation failed: #{e.message}"
    redirect_to cart_path, alert: 'There was a problem with your order.'
  end

  # GET /payments/cancel
  def cancel
    # Logic for handling cancellation
    redirect_to cart_path
  end

  private

  def calculate_cart_subtotal(cart_items)
    cart_items.sum do |item|
      product = Product.find(item['product_id'])
      product.price * item['quantity']
    end
  end

  def calculate_order_taxes(subtotal, province)
    gst_amount = calculate_tax(subtotal, province.gst + province.pst)
    pst_or_hst_amount = province.hst.present? ? calculate_tax(subtotal, province.hst) : calculate_tax(subtotal, province.pst)
    gst_amount + pst_or_hst_amount
  end

  def determine_shipping_cost(cart_items)
    shipping_option = cart_items.first['shipping_option'] # Example, adapt as needed
    SHIPPING_COSTS[shipping_option] || 0
  end

  def calculate_tax(subtotal, tax_rate)
    tax_rate.present? ? subtotal * (tax_rate / 100.0) : 0
  end

  def calculate_total_price_from_cart(cart_items)
    subtotal = calculate_cart_subtotal(cart_items)
    tax_amount = calculate_order_taxes(subtotal, current_customer.province)
    shipping_cost = determine_shipping_cost(cart_items)
    subtotal + tax_amount + shipping_cost
  end

  def create_order_products(order, cart_items)
    cart_items.each do |item|
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
end