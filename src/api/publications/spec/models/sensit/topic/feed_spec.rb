require 'spec_helper'

module Sensit
	describe Topic::Feed do

		describe "#broadcast" do

		end

		describe "#broadcast_create" do
			before(:each) do
				topic = FactoryGirl.create(:topic, user: @user, application: nil)
				@feed = Topic::Feed.new(index: ELASTIC_INDEX_NAME, type: topic.to_param, at: Time.now, data: {"assf" => "dsdsag"})
			end
			it "calls broadcast" do
				@feed.should_receive(:broadcast).with("create")
				@feed.broadcast_create
			end
		end

		describe "#broadcast_update" do
			before(:each) do
				topic = FactoryGirl.create(:topic, user: @user, application: nil)
				@feed = Topic::Feed.new(index: ELASTIC_INDEX_NAME, type: topic.to_param, at: Time.now, data: {"assf" => "dsdsag"})
			end
			it "calls broadcast" do
				@feed.should_receive(:broadcast).with("update")
				@feed.broadcast_update
			end			
		end

		describe "#broadcast_destroy" do
			before(:each) do
				topic = FactoryGirl.create(:topic, user: @user, application: nil)
				@feed = Topic::Feed.new(index: ELASTIC_INDEX_NAME, type: topic.to_param, at: Time.now, data: {"assf" => "dsdsag"})
			end
			it "calls broadcast" do
				@feed.should_receive(:broadcast).with("destroy")
				@feed.broadcast_destroy
			end
		end

		describe "#broadcast_percolate" do
			before(:each) do
				topic = FactoryGirl.create(:topic, user: @user, application: nil)
				@feed = Topic::Feed.new(index: ELASTIC_INDEX_NAME, type: topic.to_param, at: Time.now, data: {"assf" => "dsdsag"})
			end
			it "calls broadcast" do
				@feed.should_receive(:percolate).and_return({"ok" => true, "matches" => []})
				@feed.should_receive(:publish)
				@feed.broadcast_percolate
			end
		end

		describe "#after_create" do
			before(:each) do
				topic = FactoryGirl.create(:topic, user: @user, application: nil)
				@feed = Topic::Feed.new(index: ELASTIC_INDEX_NAME, type: topic.to_param, at: Time.now, data: {"assf" => "dsdsag"})
			end
			describe 'after_create' do
				it 'should run the proper callbacks' do
					@feed.should_receive(:broadcast_create)
					@feed.should_receive(:broadcast_percolate)
					@feed.run_callbacks(:create)
				end
			end
		end

		describe "#after_update" do
			before(:each) do
				topic = FactoryGirl.create(:topic, user: @user, application: nil)
				@feed = Topic::Feed.new(index: ELASTIC_INDEX_NAME, type: topic.to_param, at: Time.now, data: {"assf" => "dsdsag"})
			end
			describe 'after_update' do
				it 'should run the proper callbacks' do
					@feed.should_receive(:broadcast_update)
					@feed.run_callbacks(:update)
				end
			end
		end

		describe "#after_destroy" do
			before(:each) do
				topic = FactoryGirl.create(:topic, user: @user, application: nil)
				@feed = Topic::Feed.new(index: ELASTIC_INDEX_NAME, type: topic.to_param, at: Time.now, data: {"assf" => "dsdsag"})
			end
			describe 'after_destroy' do
				it 'should run the proper callbacks' do
					@feed.should_receive(:broadcast_destroy)
					@feed.run_callbacks(:destroy)
				end
			end
		end

		# describe "#create" do
		# 	before(:each) do
		# 		@indices_client = Elasticsearch::API::Indices::IndicesClient.new(@client)
		# 		@feed = Topic::Feed.new({index: 'myindex', type: 'mytype', at: Time.now, data: {title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}})
		# 	end
		# 	# context "when the index doesn't exist (called for first time)" do
		# 	# 	before(:each) do
		# 	# 		@indices_client.stub(:exists).and_return(false)
		# 	# 	end
		# 	# 	it "creates the index" do
		# 	# 		@indices_client.should_receive(:create)
		# 	# 		@client.stub(:indices).and_return(@indices_client)
		# 	# 		Topic::Feed.stub(:elastic_client).and_return(@client)
		# 	# 		feed = Topic::Feed.create(@params)
		# 	# 	end

		# 	# end
		# 	context "when the index does exist" do
		# 		before(:each) do
		# 			@indices_client.stub(:exists).and_return(true)
		# 		end
		# 		context "with valid response" do
		# 			it "executes the elastic create action" do
		# 				@client.should_receive(:create).with({:index=>"myindex", :type=>"mytype", :body=>{:title=>"Test 1", :tags=>["y", "z"], :published=>true, :counter=>1, :at=>@feed.at.utc.to_f, :tz=>"UTC"}}).and_return({"ok"=>true, "_index"=>'myindex', "_type"=>'mytype', "_id"=>"8eI2kKfwSymCrhqkjnGYiA", "_version"=>1})
		# 				@feed.stub(:faye_broadcast).and_return(true)
		# 				@feed.stub(:percolate).and_return({"ok" => true, "matches" => []})
		# 				Topic::Feed.stub(:elastic_client).and_return(@client)
		# 				@feed.send(:create)
		# 			end
		# 			context "" do
		# 				before(:each) do
		# 					@client.stub(:create).and_return({"ok"=>true, "_index"=>'myindex', "_type"=>'mytype', "_id"=>"8eI2kKfwSymCrhqkjnGYiA", "_version"=>1})
		# 					Topic::Feed.stub(:elastic_client).and_return(@client)
		# 				end

		# 				it "broacasts that the the feed has been added" do
		# 					@feed.stub(:percolate).and_return({"ok" => true, "matches" => []})
		# 					@feed.should_receive(:faye_broadcast).and_return(true)
		# 					@feed.send(:create)
		# 				end
		# 				context "able to connection to broadcast server" do
		# 					before(:each) do
		# 						@feed.stub(:faye_broadcast).and_return(true)
		# 					end
		# 					context "with percolation matches" do
		# 						before(:each) do
		# 							@feed.stub(:percolate).and_return({"ok" => true, "matches" => ["foobar"]})
		# 						end
		# 						it "broadcasts the match" do
		# 							@feed.should_receive(:faye_broadcast).with("foobar").and_return(true)
		# 							@feed.send(:create)
		# 						end
		# 					end
		# 					context "with no percolation matches" do
		# 						before(:each) do
		# 							@feed.stub(:percolate).and_return({"ok" => true, "matches" => []})
		# 						end
		# 						it "sets the id on the instance" do
		# 							@feed.send(:create)
		# 							@feed.id.should == "8eI2kKfwSymCrhqkjnGYiA"
		# 						end

		# 						it "returns whether it was successful" do
		# 							success = @feed.send(:create)
		# 							success.should be_true
		# 						end

		# 						it "is no longer a new record" do
		# 							@feed.send(:create)
		# 							@feed.should_not be_a_new_record
		# 						end	
		# 					end
		# 				end
		# 				context "Unable to connect to broadcast server" do
		# 					it "throws an exception" do
		# 						# Errno::ECONNREFUSED
		# 					end
		# 				end
		# 			end
		# 		end
		# 	end
		# end		
	end
end