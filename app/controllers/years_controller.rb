class YearsController < ApplicationController
  # GET /years
  #
  # Returns years registered for the income/expense report
  def index
    render json: Year.all
  end

  # GET /years/:year
  #
  # Returns years registered for the income/expense report
  def show
    year = Year.find(params[:year])
    if year.present?
      render json: year.months
    else
      render json: { message: "Year #{params[:year]} was not found" }, status: :not_found
    end
  end
end
