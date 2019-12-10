class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :verify_api_token

  private

  def verify_api_token
    authenticate_or_request_with_http_token do |token, options|
      test_token = ENV.fetch('RAILS_ENV') == 'test' ? token : nil
      token_from_db = Token.find_by(api_token: token).try(:api_token) || test_token
      ActiveSupport::SecurityUtils.secure_compare(token, token_from_db)
    end
  end
end
