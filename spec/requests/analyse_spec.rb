require 'rails_helper'

RSpec.describe 'Analysis API', type: :request do
  describe 'POST /analyse' do
    let(:endpoint) { '/analyse' }
    let(:json) { JSON(response.body, symbolize_names: true)  }
    let(:statement) { {
      title: 'Some Purchase London',
      category: 'Food',
      date: '2019-01-01',
      amount: 200,
      type: 'income'
    }}

    it 'returns status code 400 when no statement is passed' do
      post endpoint
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns status code 200 on correct statements array' do
      post endpoint, params: { statement: [] }
      expect(response).to have_http_status(:ok)
    end

    it 'returns the same amount of statement entries passed' do
      post endpoint, params: { statement: [statement] }
      expect(json.size).to eq(1)
    end

    it 'returns statement category empty when no keywords' do
      Statement.collection.drop

      post endpoint, params: { statement: [statement] }
      expect(json[0][:category]).to eq('')
    end

    it 'returns statement category when sentence is registered' do
      Statement.collection.drop
      statement[:id] = statement[:title]
      Statement.create(statement.except(:title, :type, :date, :amount))

      post endpoint, params: { statement: [statement] }
      expect(json[0][:category]).to eq(statement[:category])
    end

    it 'returns same id field so this could be identified later' do
      Statement.collection.drop
      statement[:id] = 'test123'

      post endpoint, params: { statement: [statement] }
      expect(json[0][:id]).to eq(statement[:id])
    end
  end
end
