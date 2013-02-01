require "spec_helper"

describe HashDB::Model do
  context ".has_many" do
    it "should allow assigning and retrieving objects" do
      post = Class.new do
        include HashDB::Model
      end

      user = Class.new do
        include HashDB::Model
        has_many :posts, foreign_key: :user_id, class: post
      end

      u1 = user.create
      p1 = post.create
      u1.posts << p1
      p2 = u1.posts.create

      u1.posts.size.should eq 2
      p1.user_id.should eq u1.id
      p2.user_id.should eq u1.id
    end
  end
end
