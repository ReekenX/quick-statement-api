require "rails_helper"

RSpec.describe "FactoryBot" do
  it "all factories valid" do
    FactoryBot.lint
  end
end
