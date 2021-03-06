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

  context ".primary_key" do
    it "should have :id as primary key by default" do
      model.primary_key.should eq :id
    end

    it "should save primary key" do
      model.primary_key :name
      model.primary_key.should eq :name
    end
  end

  context ".new" do
    it "should assign passed args into keys" do
      model.keys :integer, :string
      m1 = model.new integer: 1, string: "test"
      m1.integer.should eq 1
      m1.string.should eq "test"
    end

    it "should raise ArgumentError if an invalid key is passed" do
      expect { model.new invalid: 1 }.to raise_exception HashDB::InvalidKeyError
    end
  end

  context ".create" do
    it "should instantiate and save object" do
      model.keys :integer
      m1 = model.create
      m2 = model.create integer: 10
      model.all.should eq({1 => m1, 2 => m2})
      m2.integer.should eq 10
    end
  end

  context "#save" do
    it "should assign id to models after they are saved" do
      m1 = model.new.save
      m1.id.should eq 1
      m2 = model.new
      m3 = model.new.save
      m3.id.should eq 2
    end

    it "should save model into Class.all" do
      m1 = model.new
      m2 = model.new.save
      m3 = model.new.save
      model.all.should eq({ 1 => m2, 2 => m3 })
    end
  end

  context "#destroy" do
    it "should remove object from model.all" do
      m1 = model.create
      m2 = model.create
      m1.destroy
      model.all.should eq({ 2 => m2 })
      m2.destroy
      model.all.should be_empty
    end
  end
end
