require 'rails_helper'

RSpec.describe 'Months API', type: :request do
  describe 'GET /months' do
    let(:endpoint) { '/months' }
    let(:json) { JSON(response.body, symbolize_names: true)  }

    it 'returns status code 200 even when no months are registered' do
      get endpoint

      expect(response).to have_http_status(:ok)
    end

    it 'returns status code 200 on months list' do
      Month.create(id: '2019-01')
      get endpoint

      expect(response).to have_http_status(:ok)
    end

    it 'returns status code 200 on months list' do
      Month.create(id: '2019-01')
      Month.create(id: '2019-02')
      get endpoint

      expect(json.size).to eq(2)
    end
  end
end
