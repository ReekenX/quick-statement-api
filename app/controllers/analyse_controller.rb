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
      sentence = Statement.find(entry['title'])
      entry['category'] = sentence.present? ? sentence.category : ''
      entry
    end
  end
end
