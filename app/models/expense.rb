class Expense
  include Mongoid::Document

  field :title, type: String
  field :date, type: String
  field :amount, type: Integer
  field :category, type: String
end
