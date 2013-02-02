require "spec_helper"

describe HashDB::Model do
  let :model do
    Class.new do
      include HashDB::Model
      keys :integer, :string
    end
  end

  context ".where" do
    context "with hash" do
      it "should filter by key(s) = value(s)" do
        m1 = model.create integer: 4, string: "a"
        m2 = model.create integer: 4, string: "b"
        m3 = model.create string: "c"
        m4 = model.create string: "b"

        model.where(integer: 4).should eq [m1, m2]
        model.where(string: "b").should eq [m2, m4]
        model.where(string: "d").should eq []
        model.where(integer: 4, string: "b").should eq [m2]
      end
    end

    context "with array" do
      it "should filter by [key, method, value](s)" do
        m1 = model.create integer: 1
        m2 = model.create integer: 2
        m3 = model.create integer: 3
        m4 = model.create integer: 4
        model.where(:integer, :<, 2).should eq [m1]
        model.where(:integer, :>, 2).should eq [m3, m4]
        model.where([:integer, :>, 0], [:integer, :<, 3]).should eq [m1, m2]
      end
    end
  end

  context ".find_by" do
    it "should delegate to .where.first" do
      model.should_receive(:where).with(:integer, :<, 10).and_return([])
      model.find_by(:integer, :<, 10).should eq nil
    end
  end

  context ".find" do
    it "should delegate to find_by with key = model.primary_key" do
      model.should_receive(:find_by).with(name: "A").and_return(:works)
      model.primary_key :name
      model.find("A").should eq :works
    end
  end
end

