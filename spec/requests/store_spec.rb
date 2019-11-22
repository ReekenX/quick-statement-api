require 'rails_helper'

RSpec.describe 'Store API', type: :request do
  describe 'POST /store' do
    let(:endpoint) { '/store' }
    let(:json) { JSON(response.body, symbolize_names: true)  }
    let(:statement) { {
      title: 'MCDONALDS 9059353 Rang LT07156 Vilnius 2BX 28',
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

    it 'stores category to the DB' do
      post endpoint, params: { statement: [statement] }

      expect(Category.find(statement[:category])).not_to be_nil
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

    it 'stores new category if requested for existing statement' do
      post endpoint, params: { statement: [statement] }
      expect(Income.find_by(title: statement[:title]).category).to eq(statement[:category])

      statement[:category] = 'Car'
      post endpoint, params: { statement: [statement] }

      expect(Income.find_by(title: statement[:title]).category).to eq(statement[:category])
    end

    it 'does not duplicate income for the same date, title and amount' do
      post endpoint, params: { statement: [statement] }
      post endpoint, params: { statement: [statement] }

      expect(Income.count).to eq(1)
      expect(Expense.count).to eq(0)
    end

    it 'does not duplicate expense for the same date, title and amount' do
      statement[:type] = 'expense'
      post endpoint, params: { statement: [statement] }
      post endpoint, params: { statement: [statement] }

      expect(Income.count).to eq(0)
      expect(Expense.count).to eq(1)
    end

    it 'does not make duplicate categories' do
      Category.create(id: statement[:category])
      post endpoint, params: { statement: [statement] }

      expect(Category.count).to eq(1)
    end

    it 'should register keywords' do
      post endpoint, params: { statement: [statement] }

      expect(Keyword.find('mcdonalds').categories).to eq({ 'Food' => 1 })
    end

    it 'should register keywords for valid titles' do
      post endpoint, params: { statement: [statement] }

      # Should skip some words (9059353, 2BX, 28) as they are invalid names
      expect(Keyword.count).to eq(4)
    end

    it 'should increase category for duplicate keyword' do
      post endpoint, params: { statement: [statement] }
      statement[:title] = 'MCDONALDS Restorant'
      post endpoint, params: { statement: [statement] }

      expect(Keyword.find('mcdonalds').categories).to eq({ 'Food' => 2 })
    end

    it 'should add category another category for ambigous keyword' do
      post endpoint, params: { statement: [statement] }
      statement[:category] = 'Rental'
      post endpoint, params: { statement: [statement] }

      expect(Keyword.find('mcdonalds').categories).to eq({ 'Food' => 1, 'Rental' => 1})
    end
  end
end
