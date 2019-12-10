require 'rails_helper'

RSpec.describe 'Home API', type: :request do
  describe 'GET /' do
    let(:endpoint) { '/' }
    let(:json) { JSON(response.body, symbolize_names: true)  }

    it 'returns status code 200 when anonymous' do
      get endpoint
      expect(response).to have_http_status(:ok)
    end

    it 'returns success key' do
      get endpoint
      expect(json).to have_key(:status)
    end

    it 'returns date key' do
      get endpoint
      expect(json).to have_key(:date)
    end
  end
end
