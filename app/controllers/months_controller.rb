class MonthsController < ApplicationController
  # GET /months
  #
  # Returns months registered for the income/expense report
  def index
    render json: Month.all
  end
end
