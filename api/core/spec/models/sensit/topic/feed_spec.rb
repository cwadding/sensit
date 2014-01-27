require 'spec_helper'

module Sensit
  describe Topic::Feed do
	it { should validate_presence_of(:at) }
	# it { should validate_uniqueness_of(:at).scoped_to(:topic_id) }

	it { should validate_presence_of(:values) }
	it { should validate_presence_of(:type) }
	it { should validate_presence_of(:index) }
	
	before(:each) do
		@client = ::Elasticsearch::Client.new log: true
	end



	describe ".count" do
		context "when the index exists" do
			before(:each) do
				@params = {index: "transactions", type: "atm"}
			end
			it "executes the elastic count query" do
				
				@client.should_receive(:count).with(@params).and_return({"count"=>36, "_shards"=>{"total"=>5, "successful"=>5, "failed"=>0}})
				Topic::Feed.stub(:elastic_client).and_return(@client)
				feed = Topic::Feed.count(@params)
			end
			it "returns the number of rows" do
				@client.stub(:count).with(@params).and_return({"count"=>36, "_shards"=>{"total"=>5, "successful"=>5, "failed"=>0}})
				Topic::Feed.stub(:elastic_client).and_return(@client)
				feed = Topic::Feed.count(@params)
				feed.should be_an Integer
			end
		end
	end

	describe ".find" do
		context "with valid params" do
			context "when the record exists" do
				before(:each) do
					@params = {index: ELASTIC_INDEX_NAME, type: "atm", id: 'cOsusCVJQUabbfZcIdDyAg' }
					@result1 = {"_index"=>"transactions", "_type"=>"atm", "_id"=>"cOsusCVJQUabbfZcIdDyAg", "_score"=>1.0, "_source"=>{"at"=> 1384487733.546266, "qwe"=>123}}
				end
				it "executes the elastic get query" do
					@client.should_receive(:get).with(@params).and_return(@result1)

					Topic::Feed.stub(:elastic_client).and_return(@client)
					feed = Topic::Feed.find(@params)
				end
				it "returns the feed" do
					@client.stub(:get).and_return(@result1)
					Topic::Feed.stub(:elastic_client).and_return(@client)
					feed = Topic::Feed.find(@params)
					feed.should be_an_instance_of Topic::Feed
				end
			end
			context "when the record doesn't exist" do
				before(:each) do
					@params = {index: ELASTIC_INDEX_NAME, type: "atm", id: 'cOsusCVJQUabbfZcIdDyAg' }
					@client.stub(:get).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
				end
				it "throws an exception that it is not found" do
					Topic::Feed.stub(:elastic_client).and_return(@client)
					expect{
						Topic::Feed.find(@params)
					}.to raise_error(::Elasticsearch::Transport::Transport::Errors::NotFound)
				end
			end
		end
		context "with invalid params" do
			before(:each) do
				@params = {index: ELASTIC_INDEX_NAME, type: "fsd", id: 'cOsusCVJQUabbfZcIdDyAg' }
				@client.stub(:get).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
			end
			it "throws an exception that it is not found" do
				Topic::Feed.stub(:elastic_client).and_return(@client)
				expect{
					Topic::Feed.find(@params)
				}.to raise_error(::Elasticsearch::Transport::Transport::Errors::NotFound)
			end				
		end
	end

	describe ".create" do
		before(:each) do
			@params = {index: ELASTIC_INDEX_NAME, type: 'mytype', at: Time.now, values: {title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}}
			@feed = Topic::Feed.new(@params)
		end
		it "executes the create instance" do
			@feed.should_receive(:create).and_return(true)
			Topic::Feed.should_receive(:new).with(@params).and_return(@feed)
			feed = Topic::Feed.create(@params)
		end

		it "returns a Feed" do
			@feed.stub(:create).and_return(true)
			Topic::Feed.stub(:new).with(@params).and_return(@feed)
			feed = Topic::Feed.create(@params)
			feed.should be(@feed)
		end
	end

	describe ".search" do
		before(:each) do
			@params = {index: ELASTIC_INDEX_NAME, type: "atm", body: { :query => {"match_all" => {  }} }}
			@result1 = {"_index"=>"3","_type"=>"3","_id"=>"vVHkzUTuThOTpl-tstkzhg","_score"=>1.0, "_source" => {"at"=>1384743416.433696}}
			@result2 = {"_index"=>"3","_type"=>"3","_id"=>"1ZiRp7VHSHK_-3NmoJjusQ","_score"=>1.0, "_source" => {"at"=>1384743416.530578}}
			@results = {"took" => 2,"timed_out" => false, "_shards" => {"total" => 5,"successful" => 5,"failed" => 0},"hits" => {"total"=>2,"max_score"=>1.0,"hits"=>[@result1,@result2]}}
		end
		it "executes the elastic search query" do
			@client.should_receive(:search).with(@params).and_return(@results)
			Topic::Feed.stub(:elastic_client).and_return(@client)
			feeds = Topic::Feed.search(@params)
		end

		it "returns an array of Feeds" do
			@client.stub(:search).and_return(@results)
			Topic::Feed.should_receive(:map_results).with(@result1).and_return(Topic::Feed.new)
			Topic::Feed.should_receive(:map_results).with(@result2).and_return(Topic::Feed.new)

			Topic::Feed.stub(:elastic_client).and_return(@client)

			feeds = Topic::Feed.search(@params)

			feeds.should be_an_instance_of Array
			feeds.each do |feed|
				feed.should be_an_instance_of Topic::Feed
			end
		end
	end

	describe ".percolate" do
		before(:each) do
			@params = {index: ELASTIC_INDEX_NAME, type: "atm", body: { query: {"match_all" => {  }} } }
		end
		it "executes the elastic percolate query" do
			@client.should_receive(:percolate).with(@params).and_return({})
			Topic::Feed.stub(:elastic_client).and_return(@client)
			feed = Topic::Feed.percolate(@params)
		end
	end		

	describe "#topic" do
		it "returns its parent topic" do
			Topic.stub(:find).with("atm").and_return(Topic.new)
			feed = Topic::Feed.new(index: "transactions", type: "atm")
			feed.topic.should be_an_instance_of Topic
		end
	end


	describe ".destroy" do
		before(:each) do
			@params = {index: ELASTIC_INDEX_NAME,type: 'mytype', id: '1'}
		end
		context "when the record exists" do
			it "executes the elastic delete" do
				@client.should_receive(:delete).with(@params).and_return({"ok"=>true, "found"=>true, "_index"=>"transactions", "_type"=>"atm", "_id"=>"8eI2kKfwSymCrhqkjnGYiA", "_version"=>4})
				Topic::Feed.stub(:elastic_client).and_return(@client)
				Topic::Feed.destroy(@params)
			end
		end
		context "when the record does not exist" do
			it "throws an exception that it is not found" do
				@client.stub(:delete).with(@params).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
				Topic::Feed.stub(:elastic_client).and_return(@client)
				expect{
					Topic::Feed.destroy(@params)
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
				@indices_client.should_receive(:delete).with({index: ELASTIC_INDEX_NAME}).and_return({"ok"=>true, "acknowledged"=>true})
				@client.stub(:indices).and_return(@indices_client)
				Topic::Feed.stub(:elastic_client).and_return(@client)
				Topic::Feed.destroy_all({index: ELASTIC_INDEX_NAME})
			end
		end
		context "when the index does not exist" do
			it "throws an exception that it is not found" do
				@indices_client.should_receive(:delete).with({index: ELASTIC_INDEX_NAME}).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
				@client.stub(:indices).and_return(@indices_client)
				Topic::Feed.stub(:elastic_client).and_return(@client)
				expect{
					Topic::Feed.destroy_all({index: ELASTIC_INDEX_NAME})
				}.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
			end
		end
	end

	describe "#topic=" do
		before(:each) do
			@topic = Topic.new(:name => "MyTopic")
			@topic.stub(:id).and_return(1)
		end
		it "sets the type from the topic" do
			feed = Topic::Feed.new
			feed.topic = @topic
			feed.type.should == @topic.id
		end
		it "checks that the parameter is a Topic" do
			feed = Topic::Feed.new
			class SomeClass; end
			expect{
				feed.topic = SomeClass.new
			}.to raise_error(::TypeError)
		end
	end

	describe "#create" do


		before(:each) do
			@indices_client = Elasticsearch::API::Indices::IndicesClient.new(@client)
			@feed = Topic::Feed.new({index: ELASTIC_INDEX_NAME, type: 'mytype', at: Time.now, values: {title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}})
			# @params = {index: ELASTIC_INDEX_NAME, type: 'mytype', at: Time.now, values: {title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}}
			# {index: ELASTIC_INDEX_NAME,type: 'mytype', body: {title: 'Test 1',tags: ['y', 'z'], published: true, published_at: Time.now.utc.iso8601, counter: 1}}
		end
		# context "when the index doesn't exist (called for first time)" do
		# 	before(:each) do
		# 		@indices_client.stub(:exists).and_return(false)
		# 	end
		# 	it "creates the index" do
		# 		@indices_client.should_receive(:create)
		# 		@client.stub(:indices).and_return(@indices_client)
		# 		Topic::Feed.stub(:elastic_client).and_return(@client)
		# 		feed = Topic::Feed.create(@params)
		# 	end

		# end
		context "when the index does exist" do
			before(:each) do
				@indices_client.stub(:exists).and_return(true)
			end
			context "with valid response" do
				it "executes the elastic create action" do
					@client.should_receive(:create).with({index: ELASTIC_INDEX_NAME, :type=>"mytype", :body=>{:title=>"Test 1", :tags=>["y", "z"], :published=>true, :counter=>1, :at=>@feed.at.utc.to_f, :tz=>"UTC"}}).and_return({"ok"=>true, "_index"=> @user.to_param, "_type"=>'mytype', "_id"=>"8eI2kKfwSymCrhqkjnGYiA", "_version"=>1})
					Topic::Feed.stub(:elastic_client).and_return(@client)
					@feed.send(:create)
				end
				context "" do
					before(:each) do
						@client.stub(:create).and_return({"ok"=>true, "_index"=> @user.to_param, "_type"=>'mytype', "_id"=>"8eI2kKfwSymCrhqkjnGYiA", "_version"=>1})
						Topic::Feed.stub(:elastic_client).and_return(@client)
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
			@feed = Topic::Feed.new({index: ELASTIC_INDEX_NAME, type: 'mytype', at: Time.now, values: {title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}})
			@feed.stub(:id).and_return(3)
			@feed.stub(:new_record?).and_return(false)
		end
		it "executes the update class action" do
			@client.should_receive(:update).with({index: ELASTIC_INDEX_NAME, type: 'mytype', id: 3, body:{ doc:{ at: @feed.at.utc.to_f, :tz=>"UTC", title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}}}).and_return({"ok"=>true, "_index"=>"#{@user.to_param}", "_type"=>'mytype', "_id"=>"8eI2kKfwSymCrhqkjnGYiA", "_version"=>2})
			@feed.stub(:elastic_client).and_return(@client)
			success = @feed.send(:update)
		end

		it "returns true when update is successful" do
			@client.stub(:update).and_return({"ok"=>true, "_index"=>"#{@user.to_param}", "_type"=>"mytype", "_id"=>"8eI2kKfwSymCrhqkjnGYiA", "_version"=>3})
			@feed.stub(:elastic_client).and_return(@client)
			success = @feed.send(:update)
			success.should be_true
		end	
	end	



	describe "#destroy" do
		before(:each) do
			@feed = Topic::Feed.new({index: ELASTIC_INDEX_NAME, type: 'mytype', at: Time.now, values: {title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}})
		end
		context "when the record is not a new record" do
			before(:each) do
				@feed.stub(:id).and_return(1)
				@feed.stub(:new_record?).and_return(false)
			end
			it "executes the elastic delete" do
				Topic::Feed.should_receive(:destroy).with({index: ELASTIC_INDEX_NAME, type: 'mytype', id: 1}).and_return(true)
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
			@feed = Topic::Feed.new({index: ELASTIC_INDEX_NAME, type: 'mytype', at: Time.now, values: {title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}})
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
