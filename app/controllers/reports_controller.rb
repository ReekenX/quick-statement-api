class ReportsController < ApplicationController
  # GET /reports
  #
  # Returns global income/expenses report
  def index
    render json: {
      income: Income.all.map{|e| e.amount}.sum || 0,
      expense: Expense.all.map{|e| e.amount}.sum || 0
    }
  end

  # GET /reports/:year/:month
  #
  # Returns global income/expenses report
  def show
    result = {
      total: {
        income: Income.all.map{|e| e.date.starts_with?(date_slug) ? e.amount : 0 }.sum || 0,
        expense: Expense.all.map{|e| e.date.starts_with?(date_slug) ? e.amount : 0 }.sum || 0,
      },
      categories: {}
    }

    Category.all.each do |category|
      result[:categories][category.id] = {
        income: Income.all.map{|e| e.date.starts_with?(date_slug) && e.category == category.id ? e.amount : 0 }.sum || 0,
        expense: Expense.all.map{|e| e.date.starts_with?(date_slug) && e.category == category.id ? e.amount : 0 }.sum || 0,
      }
    end

    render json: result
  end

  private

  def date_slug
    "#{params[:year]}-#{params[:month]}-"
  end
end
