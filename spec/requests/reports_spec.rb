require 'rails_helper'

RSpec.describe 'Reports API', type: :request do
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
      Category.create(id: 'Food', type: 'expense')
      Category.create(id: 'Salary', type: 'income')
      Expense.create(entry.merge(amount: 10, category: 'Food'))
      Income.create(entry.merge(amount: 1000, category: 'Salary'))

      get endpoint

      expect(json[:expense][:Food]).to eq(10)
      expect(json[:income][:Salary]).to eq(1000)
    end
  end
end
