class PaymentsController < ApplicationController
  Stripe.api_key = ENV['STRIPE_SECRET_KEY']

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

    # Here, you can implement any logic needed to handle a successful payment,
    # such as updating an order's status, sending a confirmation email, etc.

    # Redirect to the user's profile page
    redirect_to profile_path
  end

  # GET /payments/cancel
  def cancel
    # This action handles the scenario when a user cancels the payment process.
    # You can add logic here, like logging the event or updating the order status.

    # Redirect to the cart page or another appropriate page in your application
    redirect_to cart_path  # Adjust this to where you'd like to redirect users after cancellation
  end
end
