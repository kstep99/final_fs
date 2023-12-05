class PaymentsController < ApplicationController
  # POST /payments
  def create
    cart_items = session[:cart] || []

    line_items = cart_items.map do |item|
      product = Product.find(item["product_id"])
      {
        price_data: {
          currency: 'usd',
          product_data: {
            name: product.name,
            description: product.description,
          },
          unit_amount: product.price_in_cents,
        },
        quantity: item["quantity"],
      }
    end

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: line_items,
      mode: 'payment',  # Specify the mode for the session
      success_url: payments_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: payments_cancel_url
    )

    respond_to do |format|
      format.js
    end
  end

  # GET /payments/success
  def success
    # Fetch the session ID from the URL query string
    session_id = params[:session_id]
    # Implement logic here to handle the successful payment
  end

  # GET /payments/cancel
  def cancel
    # Handle the cancellation of payment
  end
end
