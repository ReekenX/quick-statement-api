class ReportsController < ApplicationController
  # GET /reports/:year/:month
  #
  # Returns global income/expenses report
  def show
    result = {
      date: {
        year: params[:year],
        month: params[:month],
      },
      total: {
        income: Income.all.map{|e| e.date.starts_with?(date_slug) ? e.amount : 0 }.sum || 0,
        expense: Expense.all.map{|e| e.date.starts_with?(date_slug) ? e.amount : 0 }.sum || 0,
      },
      income: {},
      expense: {}
    }

    Category.where(type: 'income').each do |category|
      result[:income][category.id] = Income
        .where(category: category.id)
        .map{|e| e.date.starts_with?(date_slug) ? e.amount : 0 }.sum || 0
    end

    Category.where(type: 'expense').each do |category|
      result[:expense][category.id] = Expense
        .where(category: category.id)
        .map{|e| e.date.starts_with?(date_slug) ? e.amount : 0 }.sum || 0
    end

    # Sort by descending order income/expense categories
    result[:income] = result[:income].sort_by{ |_, val| val }.reverse.to_h
    result[:expense] = result[:expense].sort_by{ |_, val| val }.reverse.to_h

    render json: result
  end

  private

  def date_slug
    "#{params[:year]}-#{params[:month]}-"
  end
end
