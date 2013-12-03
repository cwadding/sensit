require 'spec_helper'

module Sensit
  describe Topic do
    # it {should have_many(:feeds).dependent(:destroy)}
    it {should have_many(:fields).dependent(:destroy)}
    it {should have_many(:subscriptions).dependent(:destroy)}
    it {should have_many(:reports).dependent(:destroy)}

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }

    describe "#feeds" do
    	it "returns the associated feeds" do

    	end
    end

    describe "#percolations" do
        it "returns the associated percolations" do

        end
    end

    describe "#destroy_feeds" do

    end

    describe "after destroy callback" do
		it "should touch the destroy_feeds"# do
			# @post = Factory.build(:post)
			# @post.discussion.should_receive(:touch)
			# @post.save!
		#end
	end
  end
end
