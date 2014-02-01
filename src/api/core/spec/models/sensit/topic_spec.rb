require 'spec_helper'

module Sensit
  describe Topic do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should belong_to :user }
    

    describe "#feeds" do
        before(:each) do
            @topic = FactoryGirl.create(:topic, user: @user, application: nil)
            @feed = Sensit::Topic::Feed.create({index: ELASTIC_INDEX_NAME, type: @topic.to_param, at: Time.now, :tz => "UTC", values: {value1: 2}})
        end
    	it "returns the associated feeds" do
            if ENV['ELASTICSEARCH_URL']
              client = ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'])
            else
              client = ::Elasticsearch::Client.new
            end
            client.indices.refresh(index: ELASTIC_INDEX_NAME)
            feeds = @topic.feeds
            feeds.count.should == 1
            feeds.first.should be_a_instance_of Sensit::Topic::Feed
            feeds.first.at.to_f.should == @feed.at.to_f
    	end
    end

    describe "#destroy_feeds" do
        
        before(:each) do
            @topic = FactoryGirl.create(:topic, user: @user, application: nil)
            feed = Sensit::Topic::Feed.create({index: ELASTIC_INDEX_NAME, type: @topic.to_param, at: Time.now, :tz => "UTC", values: {value1: 3}})
        end
        it "returns the associated feeds" do
            if ENV['ELASTICSEARCH_URL']
              client = ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'])
            else
              client = ::Elasticsearch::Client.new
            end
          client.indices.refresh(index: ELASTIC_INDEX_NAME)
          expect {
            @topic.destroy_feeds
            client.indices.refresh(index: ELASTIC_INDEX_NAME)
          }.to change{::Sensit::Topic::Feed.count({index: ELASTIC_INDEX_NAME, type: @topic.to_param})}.by(-1)
        end
    end

    describe "after destroy callback" do
		it "should touch the destroy_feeds" do
            topic = FactoryGirl.create(:topic, user: @user, application: nil)
            topic.should_receive(:destroy_feeds)
            topic.destroy
		end
	end    
  end
end
