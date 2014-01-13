require 'spec_helper'
require "csv"

module Sensit
	describe Topic::Feed::Importer do
		before(:each) do
			@client = ::Elasticsearch::Client.new log: true
			@topic = FactoryGirl.create(:topic_with_feeds, user: @user)
		end

		# describe "#load_feeds" do
		# 	it "creates an CSV instance" do
		# 		@client.stub(:create).and_return({"ok"=>true, "_index"=>'myindex', "_type"=>'mytype', "_id"=>"8eI2kKfwSymCrhqkjnGYiA", "_version"=>1})
		# 		@client.stub(:percolate).and_return({"ok" => true, "matches" => []})
		# 		Topic::Feed.stub(:elastic_client).and_return(@client)
		# 		importer = Topic::Feed::Importer.new
		# 		file = fixture_file_upload("#{RSpec.configuration.fixture_path}/files/feeds.csv", 'text/csv')
		# 		feeds = importer.send(:load_feeds,file)
		# 		feeds.should be_an_instance_of(Array)
		# 		feeds.each do |feed|
		# 			feed.should be_an_instance_of(Sensit::Topic::Feed)
		# 		end
		# 	end

		# end

	    # def open_spreadsheet
	    #   case File.extname(file.original_filename)
	    #     when ".csv" then Csv.new(file.path, nil, :ignore)
	    #     when ".xls" then Excel.new(file.path, nil, :ignore)
	    #     when ".xlsx" then Excelx.new(file.path, nil, :ignore)
	    #     else raise "Unknown file type: #{file.original_filename}"
	    #   end
	    # end

		describe "#open_spreadsheets" do
			# context "CSV" do

			# 	it "creates an CSV instance" do
			# 		importer = Topic::Feed::Importer.new
			# 		file = fixture_file_upload("#{RSpec.configuration.fixture_path}/files/feeds.csv", 'text/csv')
			# 		importer.send(:open_spreadsheets, file)
			# 		importer.open_spreadsheets.each do |spreadsheet|
			# 			spreadsheet.should be_an_instance_of(Array)
			# 			spreadsheet.each do |row|
			# 				row.should be_an_instance_of(Array)
			# 			end
			# 		end
			# 	end
			# end

			# context "XLS" do
			# 	before(:each) do
			# 		@file = Tempfile.new('foo.xls')
			# 		@file.stub(:original_filename).and_return('foo.xls')
			# 		@file.write("")
			# 	end
			# 	after(:each) do
			# 		@file.close
			# 		@file.unlink
			# 	end
			# 	it "creates an XLS instance" do
			# 		importer = Topic::Feed::Importer.new(file: @file)
			# 		importer.open_spreadsheet.should be_an_instance_of(::Roo::Excel)
			# 	end
			# end

			# context "XLSX" do
			# 	before(:each) do
			# 		@file = File.new('foo.xlsx')
			# 		@file.stub(:original_filename).and_return('foo.xlsx')
			# 		@file.write("")
			# 	end
			# 	after(:each) do
			# 		@file.close
			# 		@file.unlink
			# 	end
			# 	it "creates an XLS instance" do
			# 		importer = Topic::Feed::Importer.new(file: @file)
			# 		importer.open_spreadsheet.should be_an_instance_of(::Roo::Excelx)
			# 	end
			# end

			# context "Unknown format" do
			# 	it "throws an exception" do
			# 		importer = Topic::Feed::Importer.new({index: ELASTIC_SEARCH_INDEX_NAME, type: @topic.to_param :feeds => fixture_file_upload("#{RSpec.configuration.fixture_path}/files/somefile.asd", 'text/csv'), :fields => @topic.fields})
			# 		expect {
			# 			importer.open_spreadsheet
			# 		}.to raise_error(RuntimeError) #: Unknown file type: foo.asd"Unknown file type: asd")
			# 	end
			# end		
		end
	end
end




