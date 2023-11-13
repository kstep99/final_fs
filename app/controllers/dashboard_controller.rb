# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  before_action :authenticate_customer!

  def index
    # Dashboard code goes here
  end
end
