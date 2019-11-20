require 'rails_helper'

RSpec.describe 'Store API', type: :request do
  describe 'POST /store' do
    let(:endpoint) { '/store' }
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

    it 'stores statement to the DB' do
      post endpoint, params: { statement: [statement] }
      expect(Statement.find(statement[:title])).not_to be_nil
    end

    it 'stores category to the DB' do
      post endpoint, params: { statement: [statement] }
      expect(Category.find(statement[:category])).not_to be_nil
    end

    it 'does not make duplicate categories' do
      Category.create(id: statement[:category])
      post endpoint, params: { statement: [statement] }
      expect(Category.count).to eq(1)
    end

    it 'stores income entry to the DB' do
      statement[:type] = 'income'
      post endpoint, params: { statement: [statement] }
      expect(Expense.count).to eq(0)
      expect(Income.count).to eq(1)
    end

    it 'stores expense entry to the DB' do
      statement[:type] = 'expense'
      post endpoint, params: { statement: [statement] }
      expect(Expense.count).to eq(1)
      expect(Income.count).to eq(0)
    end
  end
end
