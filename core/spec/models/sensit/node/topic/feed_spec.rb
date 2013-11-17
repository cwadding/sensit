require 'spec_helper'

module Sensit
  describe Node::Topic::Feed do#, :current => true do
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
				before(:each) do
					@params = {index: "transactions", type: "atm", id: 'cOsusCVJQUabbfZcIdDyAg' }
					@client.stub(:get).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
				end
				it "throws an exception that it is not found" do
					Node::Topic::Feed.stub(:elastic_client).and_return(@client)
					expect{
						Node::Topic::Feed.find(@params)
					}.to raise_error(::Elasticsearch::Transport::Transport::Errors::NotFound)
				end
			end
		end
		context "with invalid params" do
			before(:each) do
				@params = {index: "transactions", type: "fsd", id: 'cOsusCVJQUabbfZcIdDyAg' }
				@client.stub(:get).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
			end
			it "throws an exception that it is not found" do
				Node::Topic::Feed.stub(:elastic_client).and_return(@client)
				expect{
					Node::Topic::Feed.find(@params)
				}.to raise_error(::Elasticsearch::Transport::Transport::Errors::NotFound)
			end				
		end
	end

	describe ".create" do
		before(:each) do
			@params = {index: 'myindex', type: 'mytype', topic_id: 3, at: Time.now, data: {title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}}
			@feed = Node::Topic::Feed.new(@params)
		end
		it "executes the create instance",:current => true do
			@feed.should_receive(:create).and_return(true)
			Node::Topic::Feed.should_receive(:new).with(@params).and_return(@feed)
			feed = Node::Topic::Feed.create(@params)
		end

		it "returns a Feed" do
			@feed.stub(:create).and_return(true)
			Node::Topic::Feed.stub(:new).with(@params).and_return(@feed)
			feed = Node::Topic::Feed.create(@params)
			feed.should be(@feed)
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
			@client.stub(:search).and_return([@result1, @result2])
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
		before(:each) do
			@params = {index: "transactions", type: "atm", body: { query: { term: { topic_id: 1 } } } }
		end
		it "executes the elastic percolate query" do
			@client.should_receive(:percolate).with(@params).and_return({})
			Node::Topic::Feed.stub(:elastic_client).and_return(@client)
			feed = Node::Topic::Feed.percolate(@params)
		end
	end		

	describe "#topic" do
		it "returns its parent topic" do
			Node::Topic.stub(:find).with(3).and_return(Node::Topic.new)
			feed = Node::Topic::Feed.new(index: "transactions", type: "atm", topic_id: 3)
			feed.topic.should be_an_instance_of Node::Topic
		end
	end

	describe ".count" do
		before(:each) do
			@params = {index: "transactions", type: "atm"}
		end
		it "executes the percolation" do
			@client.should_receive(:count).with(@params)
			Node::Topic::Feed.stub(:elastic_client).and_return(@client)
			feeds = Node::Topic::Feed.count(@params)
		end
	end


	describe ".destroy" do
		before(:each) do
			@params = {index: 'myindex',type: 'mytype', id: '1'}
		end
		context "when the record exists" do
			it "executes the elastic delete" do
				@client.should_receive(:delete).with(@params).and_return({"ok"=>true, "found"=>true, "_index"=>"transactions", "_type"=>"atm", "_id"=>"8eI2kKfwSymCrhqkjnGYiA", "_version"=>4})
				Node::Topic::Feed.stub(:elastic_client).and_return(@client)
				Node::Topic::Feed.destroy(@params)
			end
		end
		context "when the record does not exist" do
			it "throws an exception that it is not found" do
				@client.stub(:delete).with(@params).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
				Node::Topic::Feed.stub(:elastic_client).and_return(@client)
				expect{
					Node::Topic::Feed.destroy(@params)
				}.to raise_error(::Elasticsearch::Transport::Transport::Errors::NotFound)
			end
		end
	end

	describe ".destroy_all" do
		before(:each) do
			@indices_client = Elasticsearch::API::Indices::IndicesClient.new(@client)
			
		end
		context "when the index exists" do
			it "executes the elastic index delete" do
				@indices_client.should_receive(:delete).with({:index => "my_index"}).and_return({"ok"=>true, "acknowledged"=>true})
				@client.stub(:indices).and_return(@indices_client)
				Node::Topic::Feed.stub(:elastic_client).and_return(@client)
				Node::Topic::Feed.destroy_all({:index => "my_index"})
			end
		end
		context "when the index does not exist" do
			it "throws an exception that it is not found" do
				@indices_client.should_receive(:delete).with({:index => "my_index"}).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
				@client.stub(:indices).and_return(@indices_client)
				Node::Topic::Feed.stub(:elastic_client).and_return(@client)
				expect{
					Node::Topic::Feed.destroy_all({:index => "my_index"})
				}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			end
		end
	end	

	describe "#topic" do
		it "returns its parent topic" do
			topic_id = 1
			Node::Topic.stub(:find).with(topic_id).and_return(Node::Topic.new)
			feed = Node::Topic::Feed.new(:topic_id => 1)
			feed.topic.should be_an_instance_of Node::Topic
		end
	end

	describe "#topic=" do
		before(:each) do
			@topic = Node::Topic.new(:name => "MyTopic")
			@topic.stub(:id).and_return(1)
		end
		it "sets the topic_id from the topic" do
			feed = Node::Topic::Feed.new
			feed.topic = @topic
			feed.topic_id.should == @topic.id
		end
		it "checks that the parameter is a Node::Topic" do
			feed = Node::Topic::Feed.new
			class SomeClass; end
			expect{
				feed.topic = SomeClass.new
			}.to raise_error(::TypeError)
		end
	end

	describe "#create" do


		before(:each) do
			@indices_client = Elasticsearch::API::Indices::IndicesClient.new(@client)
			@feed = Node::Topic::Feed.new({index: 'myindex', type: 'mytype', topic_id: 3, at: Time.now, data: {title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}})
			# @params = {index: 'myindex', type: 'mytype', topic_id: 3, at: Time.now, data: {title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}}
			# {index: 'myindex',type: 'mytype', body: {title: 'Test 1',tags: ['y', 'z'], published: true, published_at: Time.now.utc.iso8601, counter: 1}}
		end
		# context "when the index doesn't exist (called for first time)" do
		# 	before(:each) do
		# 		@indices_client.stub(:exists).and_return(false)
		# 	end
		# 	it "creates the index" do
		# 		@indices_client.should_receive(:create)
		# 		@client.stub(:indices).and_return(@indices_client)
		# 		Node::Topic::Feed.stub(:elastic_client).and_return(@client)
		# 		feed = Node::Topic::Feed.create(@params)
		# 	end

		# end
		context "when the index does exist" do
			before(:each) do
				@indices_client.stub(:exists).and_return(true)
			end
			context "with valid response" do
				it "executes the elastic create action" do
					@client.should_receive(:create).with({:index=>"myindex", :type=>"mytype", :body=>{:title=>"Test 1", :tags=>["y", "z"], :published=>true, :counter=>1, :at=>@feed.at, :topic_id=>3}}).and_return({"ok"=>true, "_index"=>'myindex', "_type"=>'mytype', "_id"=>"8eI2kKfwSymCrhqkjnGYiA", "_version"=>1})
					Node::Topic::Feed.stub(:elastic_client).and_return(@client)
					@feed.send(:create)
				end
				context "" do
					before(:each) do
						@client.stub(:create).and_return({"ok"=>true, "_index"=>'myindex', "_type"=>'mytype', "_id"=>"8eI2kKfwSymCrhqkjnGYiA", "_version"=>1})
						Node::Topic::Feed.stub(:elastic_client).and_return(@client)
					end
					it "sets the id on the instance" do
						@feed.send(:create)
						@feed.id.should == "8eI2kKfwSymCrhqkjnGYiA"
					end

					it "returns whether it was successful" do
						success = @feed.send(:create)
						success.should be_true
					end

					it "is no longer a new record" do
						@feed.send(:create)
						@feed.should_not be_a_new_record
					end	
				end
			end
		end		
	end

	describe "#update" do
		before(:each) do
			@feed = Node::Topic::Feed.new({index: 'myindex', type: 'mytype', topic_id: 3, at: Time.now, data: {title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}})
			@feed.stub(:id).and_return(3)
			@feed.stub(:new_record?).and_return(false)
		end
		it "executes the update class action" do
			@client.should_receive(:update).with({index: 'myindex', type: 'mytype', id: 3, body:{ doc:{ :topic_id=>3, at: @feed.at, title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}}}).and_return({"ok"=>true, "_index"=>'myindex', "_type"=>'mytype', "_id"=>"8eI2kKfwSymCrhqkjnGYiA", "_version"=>2})
			@feed.stub(:elastic_client).and_return(@client)
			success = @feed.send(:update)
		end

		it "returns true when update is successful" do
			@client.stub(:update).and_return({"ok"=>true, "_index"=>"transactions", "_type"=>"atm", "_id"=>"8eI2kKfwSymCrhqkjnGYiA", "_version"=>3})
			@feed.stub(:elastic_client).and_return(@client)
			success = @feed.send(:update)
			success.should be_true
		end	
	end	



	describe "#destroy" do
		before(:each) do
			@feed = Node::Topic::Feed.new({index: 'myindex', type: 'mytype', topic_id: 3, at: Time.now, data: {title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}})
		end
		context "when the record is not a new record" do
			before(:each) do
				@feed.stub(:id).and_return(1)
				@feed.stub(:new_record?).and_return(false)
			end
			it "executes the elastic delete" do
				Node::Topic::Feed.should_receive(:destroy).with({index: 'myindex', type: 'mytype', id: 1}).and_return(true)
				@feed.destroy.should be_true
			end
		end
		context "when the record is a new record" do
			it "throws an exception that it is not found" do
				expect{
					@feed.destroy
				}.to raise_error(Elasticsearch::Transport::Transport::Errors::BadRequest)
			end
		end
	end	

	describe "#save" do
		before(:each) do
			@feed = Node::Topic::Feed.new({index: 'myindex', type: 'mytype', topic_id: 3, at: Time.now, data: {title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}})
		end
		context "when the record is not a new record" do
			before(:each) do
				@feed.stub(:new_record?).and_return(false)
			end
			it "updates the record" do
				@feed.should_receive(:update).and_return(true)
				@feed.save
			end
		end
		context "when the record is a new record" do
			before(:each) do
				@feed.stub(:new_record?).and_return(true)
			end
			it "creates the record" do
				@feed.should_receive(:create).and_return(true)
				@feed.save
			end
		end		
	end

  end
end
