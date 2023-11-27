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
end
