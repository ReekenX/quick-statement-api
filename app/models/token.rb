class Token
  include Mongoid::Document

  field :api_token, type: String
end
