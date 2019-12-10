require 'rails_helper'

RSpec.describe 'Analysis API', type: :request do
  describe 'POST /analyse' do
    let(:endpoint) { '/analyse' }
    let(:auth_headers) {{ HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Token.encode_credentials('test123') }}
    let(:json) { JSON(response.body, symbolize_names: true)  }
    let(:statement) { {
      title: 'MCDONALDS 9059353 Rang LT07156 Vilnius',
      category: 'Food',
      date: '2019-01-01',
      amount: 200,
      type: 'income'
    }}

    it 'returns status code 400 when no statement is passed' do
      post endpoint, headers: auth_headers

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns status code 200 on correct statements array' do
      post endpoint, params: { statement: [] }, headers: auth_headers

      expect(response).to have_http_status(:ok)
    end

    it 'returns status code 401 when not authorized but with correct statements array' do
      post endpoint, params: { statement: [] }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the same amount of statement entries passed' do
      post endpoint, params: { statement: [statement] }, headers: auth_headers

      expect(json.size).to eq(1)
    end

    it 'returns statement category empty when no keywords' do
      post endpoint, params: { statement: [statement] }, headers: auth_headers

      expect(json[0][:category]).to eq('')
    end

    it 'returns statement category when keyword is registered' do
      Keyword.create(id: 'mcdonalds', categories: { "#{statement[:category]}": 3 })
      post endpoint, params: { statement: [statement] }, headers: auth_headers

      expect(json[0][:category]).to eq(statement[:category])
    end

    it 'does not return category when keyword has multiple categories registered' do
      Keyword.create(id: 'mcdonalds', categories: { "#{statement[:category]}": 3, "Rental": 2 })
      post endpoint, params: { statement: [statement] }, headers: auth_headers

      expect(json[0][:category]).to eq('')
    end

    it 'returns same id field so this could be identified later by remote system' do
      statement[:id] = 'test123'
      post endpoint, params: { statement: [statement] }, headers: auth_headers

      expect(json[0][:id]).to eq(statement[:id])
    end
  end
end
