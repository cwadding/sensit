require 'spec_helper'

module Sensit
  describe Node::Topic::Feed, :current => truedo
	it { should validate_presence_of(:at) }
	it { should validate_presence_of(:data) }

	before(:each) do
		@client = ::Elasticsearch::Client.new log: true
	end

	describe ".find" do
		context "with valid params" do
			context "when the record exists" do
				before(:each) do
					@params = {index: "transactions", type: "atm", id: 'cOsusCVJQUabbfZcIdDyAg' }
					@result1 = {"_index"=>"transactions", "_type"=>"atm", "_id"=>"cOsusCVJQUabbfZcIdDyAg", "_score"=>1.0, "_source"=>{"topic_id"=>1, "at"=> 1384487733.546266, "qwe"=>123}}
				end
				it "executes the elastic get query" do
					@client.should_receive(:get).with(@params).and_return(@result1)

					Node::Topic::Feed.stub(:elastic_client).and_return(@client)
					feed = Node::Topic::Feed.find(@params)
				end
				it "returns the feed" do
					@client.stub(:get).and_return(@result1)
					Node::Topic::Feed.stub(:elastic_client).and_return(@client)
					feed = Node::Topic::Feed.find(@params)
					feed.should be_an_instance_of Node::Topic::Feed
				end
			end
			context "when the record doesn't exist" do
				it "throws an exception that it is not found"
			end
		end
		context "with invalid params" do
			it "throws an exception that there are invalid parameters"
		end
	end

	describe ".create" do
		context "being called for the first time" do
			it "creates the index"
			it "adds the feed to the index"
		end
		context "being called subsequent times" do
			it "adds the feed to the index"
		end
	end

	describe ".search" do
		before(:each) do
			@params = {index: "transactions", type: "atm", body: { query: { term: { topic_id: 1 } } } }
			@result1 = {"_index"=>"transactions", "_type"=>"atm", "_id"=>"CXoceLLWQdaSbEDmX_MtTg", "_score"=>1.0, "_source"=>{"topic_id"=>1, "at"=> 1384487733.546266, "qwe"=>123}}
			@result2 = {"_index"=>"transactions", "_type"=>"atm", "_id"=>"cOsusCVJQUabbfZcIdDyAg", "_score"=>1.0, "_source"=>{"topic_id"=>1, "at"=> 1384487890.546266, "qwe"=>1342323}}
		end
		it "executes the elastic search query" do
			@client.should_receive(:search).with(@params).and_return([@result1, @result2])

			Node::Topic::Feed.stub(:elastic_client).and_return(@client)

			feeds = Node::Topic::Feed.search(@params)
		end

		it "returns an array of Feeds" do
			@client.stub!(:search).and_return([@result1, @result2])
			Node::Topic::Feed.should_receive(:map_results).with(@result1).and_return(Node::Topic::Feed.new)
			Node::Topic::Feed.should_receive(:map_results).with(@result2).and_return(Node::Topic::Feed.new)

			Node::Topic::Feed.stub(:elastic_client).and_return(@client)

			feeds = Node::Topic::Feed.search(@params)

			feeds.should be_an_instance_of Array
			feeds.each do |feed|
				feed.should be_an_instance_of Node::Topic::Feed
			end
		end
	end

	describe ".percolate" do
		it "executes the percolation"
	end		

	describe "#topic" do
		it "returns its parent topic"
	end

	describe "#destroy" do
		context "when record exists" do
			it "removes the record"
		end
		context "when record doesn't exist" do
			it "throws an exception that it is not found"
		end
	end	

	describe "#save" do
		context "when the record already exists" do
			it "updates the existing record"
		end
		context "when the record doesn't exist" do
			it "creates the record"
		end		
	end

  end
end
