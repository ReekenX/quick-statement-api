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
      category = entry['category']

      # Register category if needed
      Category.find_or_create_by(id: category)

      # Register income or expense
      model = entry['type'] == 'income' ? Income : Expense
      obj = model.find_by(title: entry['title'], amount: entry['amount'], date: entry['date'])
      if obj.present?
        self.reduce_keywords_count(entry, obj['category'])
        self.incrase_keywords_count(entry)
        obj.update(category: entry['category'])
      else
        model.create(entry.except(:id, :type))
        self.incrase_keywords_count(entry)
      end
    end
  end

  protected

  # For every keyword in entry['title'] create Keyword entry and add
  # to the Keyword.categories hash count of how many times this keyword
  # was used with particular category
  def incrase_keywords_count(entry)
    category = entry['category']

    words = entry['title'].downcase.split(/[^[[:word:]]]+/)
    words
      .select do |word|
        word.size > 3 && word =~ /[a-zA-Z]+/
      end
      .each do |word|
        keyword = Keyword.find(word)
        if keyword
          keyword.update(
            categories: keyword['categories'].merge("#{category}": (keyword['categories'][category]  || 0) + 1)
          )
        else
          Keyword.create(id: word, categories: { "#{category}": 1 })
        end
      end
  end

  # Keyword category is changing, so need to change old history of
  # Keyword.categories entries
  def reduce_keywords_count(entry, category)
    words = entry['title'].downcase.split(/[^[[:word:]]]+/)
    words
      .select do |word|
        word.size > 3 && word =~ /[a-zA-Z]+/
      end
      .each do |word|
        keyword = Keyword.find(word)
        if keyword
          keyword.update(
            categories: keyword['categories'].merge("#{category}": (keyword['categories'][category]  || 1) - 1)
          )
        end
      end
  end
end
