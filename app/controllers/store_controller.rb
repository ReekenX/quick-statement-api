class StoreController < ApplicationController
  # POST /store
  #
  # Stores given statement categories to the database so this can be
  # used as future statement analysis or statement reports tool.
  #
  # Records income/expense for charting and results reporting.
  def index
    return render json: { message: 'Pass statement[] key!' }, status: :bad_request unless params[:statement]

    process_statement(statement_params[:statement])
    render json: { message: 'Statement recorded successfully.' }
  end

  private

  def statement_params
    params.permit(statement: [:id, :title, :category, :type, :date, :amount])
  end

  def process_statement(statement)
    statement.map do |entry|
      if Statement.find(entry['title']).blank?
        entry['id'] = entry['title']
        Statement.create(entry.except(:title, :date, :amount))
      end

      if Category.find(entry['category']).blank?
        Category.create(id: entry['category'])
      end

      Income.create(entry.except(:id, :type)) if entry['type'] == 'income'
      Expense.create(entry.except(:id, :type)) if entry['type'] == 'expense'
    end
  end
end
