class HomeController < ApplicationController
  skip_before_action :verify_api_token

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
