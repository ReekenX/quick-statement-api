class Year
  include Mongoid::Document

  field :months, type: Array
end
