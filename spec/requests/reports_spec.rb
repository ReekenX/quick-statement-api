require 'rails_helper'

RSpec.describe 'Reports API', type: :request do
  describe 'GET /reports' do
    let(:endpoint) { '/reports' }
    let(:json) { JSON(response.body, symbolize_names: true)  }
    let(:entry) { {
      title: 'Something',
      date: '2019-01-01',
      amount: 200,
      category: "Food"
    }}

    it 'returns status code 200' do
      get endpoint

      expect(response).to have_http_status(:ok)
    end

    it 'returns global income report' do
      Income.create(entry)

      get endpoint

      expect(json[:expense]).to eq(0)
      expect(json[:income]).to eq(200)
    end

    it 'returns global expense report' do
      Expense.create(entry)

      get endpoint

      expect(json[:expense]).to eq(200)
      expect(json[:income]).to eq(0)
    end
  end

  describe 'GET /reports/:year/:month' do
    let(:endpoint) { '/reports/2019/01' }
    let(:json) { JSON(response.body, symbolize_names: true)  }
    let(:entry) { {
      title: 'Something',
      date: '2019-01-01',
      amount: 200,
      category: "Food"
    }}

    it 'returns current month totals report' do
      Expense.create(entry)
      Expense.create(entry.merge(date: '2019-02-01'))
      Income.create(entry.merge(amount: 100))

      get endpoint

      expect(json[:total][:expense]).to eq(200)
      expect(json[:total][:income]).to eq(100)
    end

    it 'returns current month category reports' do
      Category.create(id: entry[:category])
      Expense.create(entry.merge(amount: 10))
      Expense.create(entry.merge(date: '2019-02-01'))
      Income.create(entry.merge(amount: 1))

      get endpoint

      expect(json[:categories][:Food][:income]).to eq(1)
      expect(json[:categories][:Food][:expense]).to eq(10)
    end
  end
end
