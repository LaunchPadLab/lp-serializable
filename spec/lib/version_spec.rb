require 'pry'

RSpec.describe Lp::Serializable do
  it "has a version number" do
    expect(Lp::Serializable::VERSION).not_to be nil
  end
end