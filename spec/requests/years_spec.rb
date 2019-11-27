require 'rails_helper'

RSpec.describe 'Years API', type: :request do
  describe 'GET /years' do
    let(:endpoint) { '/years' }
    let(:json) { JSON(response.body, symbolize_names: true)  }

    it 'returns status code 200 even when no years registered' do
      get endpoint

      expect(response).to have_http_status(:ok)
    end

    it 'returns status code 200 when years registered' do
      Year.create(id: '2019', months: [1, 2])
      get endpoint

      expect(response).to have_http_status(:ok)
    end

    it 'returns correct size years list' do
      Year.create(id: '2019', months: [1, 2])
      Year.create(id: '2018', months: [12])
      get endpoint

      expect(json.size).to eq(2)
    end
  end

  describe 'GET /years/:year' do
    let(:endpoint) { '/years/2019' }
    let(:json) { JSON(response.body, symbolize_names: true)  }

    it 'returns status code 404 when no such year registered' do
      get endpoint

      expect(response).to have_http_status(:not_found)
    end

    it 'returns status code 200 when year is registered' do
      Year.create(id: '2019', months: [1, 2])
      get endpoint

      expect(response).to have_http_status(:ok)
    end

    it 'returns correct size of months' do
      Year.create(id: '2019', months: [1, 2, 3])
      get endpoint

      expect(json.size).to eq(3)
    end
  end
end
