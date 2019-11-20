class HomeController < ApplicationController
  # GET /
  #
  # Returns API status
  def index
    render json: {
      status: 'ok',
      date: Time.zone.now.to_s(:db)
    }
  end
end
