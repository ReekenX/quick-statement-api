class CheckController < ApplicationController
  # GET /check
  #
  # Returns nothing. Endpoint is for API token check only.
  def index
    render json: {}
  end
end
