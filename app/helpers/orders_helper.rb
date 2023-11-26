# app/helpers/orders_helper.rb
module OrdersHelper
  def calculate_total_cost(cart_items, gst, pst, hst)
    subtotal = calculate_subtotal(cart_items)
    total_gst = subtotal * (gst || 0)
    total_pst = subtotal * (pst || 0)
    total_hst = subtotal * (hst || 0)
    subtotal + total_gst + total_pst + total_hst
  end

  private

  def calculate_subtotal(cart_items)
    # Logic to sum up the cost of items in the cart
  end
end
