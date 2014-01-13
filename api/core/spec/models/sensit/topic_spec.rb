require 'spec_helper'

module Sensit
  describe Topic do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should belong_to :user }
    describe "#feeds" do
    	it "returns the associated feeds" do
            
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
