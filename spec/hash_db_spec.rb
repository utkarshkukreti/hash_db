require "spec_helper"

describe HashDB do
  it "should have a VERSION" do
    HashDB::VERSION.should be_a String
  end
end
