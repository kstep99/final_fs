class ApplicationController < ActionController::Base

  protected

  def after_sign_in_path_for(resource)
    # Assuming you have a different dashboard for AdminUsers and Customers
    case resource
    when AdminUser
      admin_dashboard_path # This path is provided by Active Admin
    when Customer
      dashboard_index_path # This should match the path you have in routes.rb
    else
      super
    end
  end
end
