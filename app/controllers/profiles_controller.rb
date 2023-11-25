# app/controllers/profiles_controller.rb
class ProfilesController < ApplicationController
  before_action :authenticate_customer!

  def show
    @customer = current_customer
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
      redirect_to profile_path, notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:full_name, :email, :address, :city, :postal_code, :province_id, :image)
  end
end
