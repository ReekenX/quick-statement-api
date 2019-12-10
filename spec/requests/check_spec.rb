require 'rails_helper'

RSpec.describe 'Check API', type: :request do
  describe 'GET /check' do
    let(:invalid_auth_headers) {{ HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Token.encode_credentials('invalid123') }}
    let(:valid_auth_headers) {{ HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Token.encode_credentials(ENV.fetch('TEST_API_TOKEN')) }}
    let(:endpoint) { '/check' }
    let(:json) { JSON(response.body, symbolize_names: true)  }

    it 'returns status code 401 when anonymous' do
      get endpoint
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns status code 401 when invalid token' do
      get endpoint, headers: invalid_auth_headers
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns status code 200 when valid token' do
      get endpoint, headers: valid_auth_headers
      expect(response).to have_http_status(:ok)
    end
  end
end
