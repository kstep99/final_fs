# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :initialize_cart

  private

  def initialize_cart
    session[:cart] ||= []
  end

  protected

  def after_sign_in_path_for(resource)
    # If a checkout path is stored, redirect to it and delete it from the session
    checkout_path = session.delete(:checkout_path)
    return checkout_path if checkout_path.present?

    # Otherwise, continue with your existing logic for different types of users
    case resource
    when AdminUser
      admin_dashboard_path # This path is provided by Active Admin
    when Customer
      stored_location_for(resource) || root_path # Redirect customers to a stored location or the root path after login
    else
      super
    end
  end
end
