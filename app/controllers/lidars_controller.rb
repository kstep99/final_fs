class LidarsController < ApplicationController
  before_action :authenticate_customer!

  def show
    @lidar_files = current_customer.lidar_files
  end

end
