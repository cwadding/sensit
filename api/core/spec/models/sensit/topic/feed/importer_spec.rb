require 'spec_helper'
require "csv"

module Sensit
	describe Topic::Feed::Importer do
		describe "#feeds=" do
			context "with an array of feed attributes" do
				it "instantiates the feeds" do
					importer = Topic::Feed::Importer.new(index: ELASTIC_INDEX_NAME, type: "topic_id")
					feed_data = [{at: Time.now, tz: "Eastern Time (US & Canada)", values: {"assf" => "fgd"}},{at: Time.now, tz: "Eastern Time (US & Canada)", values: {"assf" => "dsdsag"}}]
					importer.feeds = feed_data
					importer.feeds.should be_an_instance_of(Array)
					importer.feeds.count.should == 2
					importer.feeds.first.should be_an_instance_of(Topic::Feed)
				end
			end

			context "with a UploadedFile" do
				it "loads the feeds from the file" do
					importer = Topic::Feed::Importer.new
					file = fixture_file_upload("/files/feeds.csv", 'text/csv')
					importer.should_receive(:load_feeds).with(file)
					importer.feeds = file
				end
			end

			context "anything else" do
				it "loads the feeds from the file" do
					expect{
						importer = Topic::Feed::Importer.new
						importer.feeds = "nothing"				
					}.to raise_error(::ArgumentError)
				end
			end			
		end

		describe "#load_feeds" do
			it "creates an CSV instance" do
				importer = Topic::Feed::Importer.new
				file = fixture_file_upload("/files/feeds.csv", 'text/csv')
				feeds = importer.send(:load_feeds,file)
				feeds.should be_an_instance_of(Array)
				feeds.each do |feed|
					feed.should be_an_instance_of(Sensit::Topic::Feed)
				end
			end
		end

		describe "#save" do
			context "with no feeds" do
				it "does nothing and returns true" do
					importer = Topic::Feed::Importer.new({index: ELASTIC_INDEX_NAME, type: "topic_id"})
					importer.save.should == true
				end
			end
			context "with all valid feeds" do
				it "persists each of the feeds" do
					importer = Topic::Feed::Importer.new({index: ELASTIC_INDEX_NAME, type: "topic_id"})
					importer.stub(:bulk_body).and_return('bulk_body')

					client = ::Elasticsearch::Client.new
					client.stub(:bulk).with({index: ELASTIC_INDEX_NAME, type: "topic_id", body: 'bulk_body'}).and_return({"took"=>2, "items"=>[{"create"=>{"_index"=>"my_index", "_type"=>"topic_id", "_id"=>"6aXcLc9TRBaEAsn09DEMLA", "_version"=>1, "ok"=>true}}]})
					importer.stub(:elastic_client).and_return(client)

					@feed = ::Sensit::Topic::Feed.new
					@feed.stub(:valid?).and_return(true)
					importer.instance_variable_set(:@feeds, [@feed])
					importer.save.should  == true
				end
			end
			context "with invalid feeds" do
				it "returns false" do
					importer = Topic::Feed::Importer.new({index: ELASTIC_INDEX_NAME, type: "topic_id"})

					@feed = ::Sensit::Topic::Feed.new
					@feed.stub(:valid?).and_return(false)
					importer.instance_variable_set(:@feeds, [@feed])
					importer.save.should  == false
				end
				it "returns adds errors" do
					importer = Topic::Feed::Importer.new({index: ELASTIC_INDEX_NAME, type: "topic_id"})

					@feed = ::Sensit::Topic::Feed.new
					importer.instance_variable_set(:@feeds, [@feed])
				end

			end
		end		

		describe "#open_spreadsheets" do
			context "" do
				around(:each) do |example|
					importer = Topic::Feed::Importer.new
					example.run
					importer.send(:open_spreadsheets, @file).each do |spreadsheet|
						spreadsheet.should be_an_instance_of(Array)
						spreadsheet.each do |row|
							row.should be_an_instance_of(Array)
						end
					end
				end
				it "can read CSV files" do
					@file = fixture_file_upload("/files/feeds.csv", 'text/csv')
				end
				it "can read XLS files" do
					@file = fixture_file_upload("/files/feeds.xls")
				end
				it "can read XLSX files" do
					@file = fixture_file_upload("/files/feeds.xlsx")
				end
				it "can read ODS files" do
					@file = fixture_file_upload("/files/feeds.ods")
				end
				it "can read a zipped CSV file" do
					@file = fixture_file_upload("/files/feeds.zip")
				end
			end

			context "Unknown format" do
				it "throws an exception" do
					file = fixture_file_upload("/files/somefile.asd")

					importer = Topic::Feed::Importer.new({
						index: ELASTIC_INDEX_NAME, 
						type: "topic_id"
					})
					expect {
						importer.send(:open_spreadsheets, file)
					}.to raise_error(RuntimeError) #: Unknown file type: foo.asd"Unknown file type: asd")
				end
			end		
		end
	end
end




