class Statement
  include Mongoid::Document

  field :category, type: String
  field :type, type: String
end
