# app/controllers/customers_controller.rb

class CustomersController < ApplicationController
  # Updated index action to retrieve alphabetized customers
  def index
    @alphabetized_customers = Customer.order(:full_name)
  end

  # Show action to find a customer by id
  def show
    @customer = Customer.find(params[:id])
  end

  # You may want to remove the alphabetized action if it's no longer needed
  # or leave it if you plan to use it for a separate alphabetized view.
  def alphabetized
    @alphabetized_customers = Customer.order(:full_name)
  end
end
