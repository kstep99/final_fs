class ApplicationController < ActionController::Base

  protected

  def after_sign_in_path_for(resource)
    # Assuming you have a different dashboard for AdminUsers and Customers
    case resource
    when AdminUser
      admin_dashboard_path # This path is provided by Active Admin
    when Customer
      root_path # Redirect customers to the products page (root path) after login
    else
      super
    end
  end
end
