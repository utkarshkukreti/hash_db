require "spec_helper"

describe HashDB::Model do
  let(:model) { Class.new { include HashDB::Model } }

  context "include" do
    it "should be includable" do
      model.ancestors.should include HashDB::Model
    end
  end

  context ".keys" do
    it "should allow assigning and retrieving attributes" do
      model.keys :integer, :string, :float, :object

      m1 = model.new

      m1.integer = 2
      m1.string = "Hello"
      m1.float = 4.2
      m1.object = m1

      m1.integer.should eq 2
      m1.string.should eq "Hello"
      m1.float.should eq 4.2
      m1.object.should eq m1
    end
  end
end
