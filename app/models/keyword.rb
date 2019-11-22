class Keyword
  include Mongoid::Document

  field :categories, type: Hash
end
