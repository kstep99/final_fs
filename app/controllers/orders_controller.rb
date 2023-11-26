# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :set_tax_rates, only: [:new, :create]

  def new
    @order = Order.new
  end

  # ... other actions ...

  private

  def set_tax_rates
    if customer_signed_in? && current_customer.province_id
      province = Province.find(current_customer.province_id)
      @gst = province.gst
      @pst = province.pst
      @hst = province.hst
    else
      # Default tax rates or nil if taxes are not applicable
      @gst = @pst = @hst = nil
    end
  end
end
