class AnalyseController < ApplicationController
  # POST /analyse
  #
  # Analyses given statement entries and returns predicted categories for them
  def index
    return render json: { message: 'Pass statement[] key!' }, status: :bad_request unless params[:statement]

    render json: process_statement(statement_params[:statement])
  end

  private

  def statement_params
    params.permit(statement: [:id, :title, :category, :type, :date, :amount])
  end

  def process_statement(statement)
    statement.map do |entry|
      categories = []
      words = entry['title'].downcase.split(/[^[[:word:]]]+/)
      words.each do |word|
        keyword = Keyword.find(word)
        if keyword && keyword.categories.count == 1
          category, _ = keyword.categories.first
          categories.push(category)
        end
      end
      entry['category'] = categories[0] || ''
      entry
    end
  end
end
