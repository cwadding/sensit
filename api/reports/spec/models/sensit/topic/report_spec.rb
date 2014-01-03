require 'spec_helper'

module Sensit
  describe Topic::Report do

	it {should belong_to :topic}

	it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:topic_id) }

    it { should validate_presence_of(:facets) }

    describe ".valid_query" do
    	before(:each) do
    		@report = Topic::Report.new({ :name => "My Report", :query => {:match_all => {}}, :facets => { "statistical" => { "field" => "num1"}}})
			@client = ::Elasticsearch::Client.new
			@indices_client = Elasticsearch::API::Indices::IndicesClient.new(@client)
			
    	end
    	context "with valid request" do
    		context "with valid query" do
				before(:each) do
					@indices_client.stub(:validate_query).and_return({"valid" => true, "_shards" => {"total" => 1,"successful" => 1,"failed" => 0}})
					@client.stub(:indices).and_return(@indices_client)
					@report.stub(:elastic_client).and_return(@client)
				end
				it "returns true" do
					@report.valid_query.should be_true
				end
			end
			context "with invalid query" do
				before(:each) do
					response = {"valid" => false, "_shards" => { "total" => 1, "successful" => 1,"failed" => 0},"explanations" => [ {"index" => "twitter", "valid" => false, "error" => "org.elasticsearch.index.query.QueryParsingException: [twitter] Failed to parse; org.elasticsearch.ElasticSearchParseException: failed to parse date field [foo], tried both date format [dateOptionalTime], and timestamp number; java.lang.IllegalArgumentException: Invalid format: \"foo\""} ]}
					@indices_client.stub(:validate_query).and_return(response)
					@client.stub(:indices).and_return(@indices_client)
					@report.stub(:elastic_client).and_return(@client)
				end
				it "returns false" do
					@report.valid_query.should be_false
				end

				it "sets the errors" do
					@report.valid_query
					@report.errors.messages.should include(:twitter)
					@report.errors.messages[:twitter] == "org.elasticsearch.index.query.QueryParsingException: [twitter] Failed to parse; org.elasticsearch.ElasticSearchParseException: failed to parse date field [foo], tried both date format [dateOptionalTime], and timestamp number; java.lang.IllegalArgumentException: Invalid format: \"foo\""
				end
			end
    	end
    	context "with invalid request" do

    	end    	
    end
  end
end
