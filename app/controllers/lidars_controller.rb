class LidarsController < ApplicationController
  before_action :authenticate_customer!

  def show
    @lidar_files = current_customer.lidar_files
  end

  def viewer
    file_name = params[:file_name]
    file_path = Rails.root.join('public', 'potree', "#{file_name}.html")

    if File.exist?(file_path)
      render file: file_path, layout: false
    else
      # Handle the case where the file does not exist
      render plain: "File not found", status: :not_found
    end
  end
end
