require "spec_helper"

describe HashDB::Model do
  context "include" do
    let(:model) { Class.new { include HashDB::Model } }
    it "should be includable" do
      model.ancestors.should include HashDB::Model
    end
  end
end
