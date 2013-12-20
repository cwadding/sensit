require 'spec_helper'
require "csv"

module Sensit
	describe Topic::Feed::Importer do
		before(:each) do
			@client = ::Elasticsearch::Client.new log: true
		end

		describe "#load_imported_feeds" do
			before(:all) do
				CSV.open("file.csv", "wb") do |csv|
				  csv << ['at','tz','field1','field2','field3','field4', 'field5']
				  csv << ['2013-12-15T21:00:15Z','UTC',1,3.2,"hello",4.5,'x']
				  csv << ['2013-12-15T21:00:30Z','UTC',2,3.78,"world",7.5,'y']
				  csv << ['2013-12-15T21:00:45Z','UTC',3,3.34,"foo",6.5,'z']
				end
			end
			it "creates an CSV instance" do
				importer = Topic::Feed::Importer.new(file: 'file.csv', :import_map => {"at" => "timestamp", "tz" => "zone", "field1" => "int", "field2" => "decimal", "field3" => "string", "field4" => "decimal"})
				spreadsheet = ::Roo::CSV.new('file.csv')
				importer.stub(:open_spreadsheet).and_return(spreadsheet)
				importer.load_imported_feeds.should == [
				  { "create" => { "data" => { "at" => 1387141215.0, "tz" => 'UTC', "field1" => 1, "field2" => 3.2,  "field3" => "hello",  "field4" => 4.5 } } },
				  { "create" => { "data" => { "at" => 1387141230.0, "tz" => 'UTC', "field1" => 2, "field2" => 3.78, "field3" => "world", "field4" => 7.5 } } },
				  { "create" => { "data" => { "at" => 1387141245.0, "tz" => 'UTC', "field1" => 3, "field2" => 3.34, "field3" => "foo",  "field4" => 6.5 } } }
				]
			end

		end

	    # def open_spreadsheet
	    #   case File.extname(file.original_filename)
	    #     when ".csv" then Csv.new(file.path, nil, :ignore)
	    #     when ".xls" then Excel.new(file.path, nil, :ignore)
	    #     when ".xlsx" then Excelx.new(file.path, nil, :ignore)
	    #     else raise "Unknown file type: #{file.original_filename}"
	    #   end
	    # end

		describe "#open_spreadsheets" do
			context "CSV" do
				before(:each) do
					@file = Tempfile.new('foo.csv')
					@file.stub(:original_filename).and_return('foo.csv')
					@file.write("")
				end
				after(:each) do
					@file.close
					@file.unlink
				end
				it "creates an CSV instance" do
					importer = Topic::Feed::Importer.new(file: @file)
					importer.open_spreadsheets.should be_a Array
					importer.open_spreadsheets.each do |spreadsheet|
						spreadsheet.should be_an_instance_of(::Roo::CSV)
					end
				end
			end

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

			context "Unknown format" do
				before(:each) do
					@file = Tempfile.new('foo.asd')
					@file.stub(:original_filename).and_return('foo.asd')
					@file.write("")
				end
				after(:each) do
					@file.close
					@file.unlink
				end
				it "throws an exception" do
					importer = Topic::Feed::Importer.new(file: @file)
					expect {
						importer.open_spreadsheet
					}.to raise_error(RuntimeError) #: Unknown file type: foo.asd"Unknown file type: asd")
				end
			end		
		end
	end
end




