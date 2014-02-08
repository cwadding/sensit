require 'spec_helper'

module Sensit
  describe Topic::Field do
    it {should belong_to :topic}

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:topic_id) }
    it { should validate_presence_of(:key) }
    it { should validate_uniqueness_of(:key).scoped_to(:topic_id) }    
    


    # maybe eventually using fuzzy logic for this
    describe "#guess_datatype" do
		before(:each) do
			@field = Topic::Field.new(:name => "my Field Name")
		end
    	context "when input value is a String type" do
			context "and the string is integer" do
				before(:each) do
					Topic::Field.stub(:to_boolean).with("-123").and_return(nil)
					Topic::Field.stub(:to_number).with("-123").and_return(123)
				end
				it "guesses the datatype for the parsed number" do
					@field.guess_datatype("-123").should == "integer"
				end		
			end
			context "and the string is a float" do
				before(:each) do
					Topic::Field.stub(:to_boolean).with("123.123").and_return(nil)
					Topic::Field.stub(:to_number).with("123.123").and_return(123.123)
				end
				it "guesses the datatype for the parsed number" do
					@field.guess_datatype("123.123").should  == "float"
				end
			end
			context "and the string is a boolean" do
				before(:each) do
					Topic::Field.stub(:to_boolean).with("true").and_return(true)
				end
				it "guesses the datatype for the parsed boolean" do
					@field.guess_datatype("true").should  == "boolean"
				end
			end

			context "and the string is a uri" do
				it "guesses the datatype for the parsed uri" do
					@field.key = "address"
					@field.guess_datatype("192.168.215.66").should  == "ip_address"
				end
			end

			context "and the string is a lat_long" do
				it "guesses the datatype for the parsed uri" do
					@field.key = "location"
					@field.guess_datatype("41.12,-71.34").should  == "lat_long"
				end
			end			

			context "and the string is a uri" do
				it "guesses the datatype for the parsed uri" do
					@field.key = "host"
					@field.guess_datatype("http://localhost:8080").should  == "uri"
				end
			end

			context "and the string is a timezone" do
				it "guesses the datatype for the parsed timezone" do
					@field.guess_datatype("UTC").should  == "timezone"
				end
			end

			context "and the string is just some text" do
				it "returns the string type" do
					@field.guess_datatype("hello world").should  == "string"
				end
			end		

			context "and the string is a formatted date or time" do
				it "guesses the datatype for the parsed number" do
					@field.guess_datatype("Wed, 02 Oct 2002 08:00:00 EST").should  == "datetime"
					@field.guess_datatype("2011-10-05T22:26:12-04:00").should  == "datetime"
					@field.guess_datatype("2011-10-05T22:26:12-04:00").should  == "datetime"
					@field.guess_datatype("20111005T222612").should  == "datetime"
					@field.guess_datatype("Wed, 05 Oct 2011 22:26:12 -0400").should  == "datetime"
					@field.guess_datatype("Thu, 06 Oct 2011 02:26:12 GMT").should  == "datetime"
					@field.guess_datatype("2011-10-31 12:00:00 -0500").should  == "datetime"
					@field.guess_datatype("12:00").should  == "datetime"
					@field.guess_datatype("2010-10-31").should  == "datetime"
					@field.guess_datatype('H13.02.03T04:05:06+07:00').should  == "datetime"
				end
			end
    	end
		context "when input value is an Fixnum type" do
			context "and the value is close to the current unix time stamp" do
				it "returns that it is a datetime" do
					value = 1.week.ago.to_i
					@field.guess_datatype(value).should == "datetime"
				end
			end

			context "and the value is close to the current unix time stamp" do
				it "returns that it is a datetime" do
					value = 1.week.ago.to_i
					@field.guess_datatype(value).should == "datetime"
				end		
			end
			context "and the value is relatively close"	do
				context "and it could be a time" do
					before(:each) do
						@field.stub(:could_be_a_time?).and_return(true)
					end
					it "returns that it is a datetime" do
						@field.guess_datatype(9.months.ago.to_i).should == "datetime"
					end
				end
				context "but it can't be a time" do
					before(:each) do
						@field.stub(:could_be_a_time?).and_return(false)
					end
					it "returns that it is an integer" do
						@field.guess_datatype(9.months.ago.to_i).should == "integer"
					end
				end				
			end
			context "the value is not close to a the curruent unix timestamp" do
				it "returns that it is an integer" do
					@field.guess_datatype(10).should == "integer"
				end
			end
		end

		context "when input value is an Float type" do
			context "and the value is close to the current unix time stamp" do
				it "returns that it is a datetime" do
					value = 1.week.ago.to_f
					@field.guess_datatype(value).should == "datetime"
				end
			end

			context "and the value is close to the current unix time stamp" do
				it "returns that it is a datetime" do
					value = 1.week.ago.to_f
					@field.guess_datatype(value).should == "datetime"
				end			
			end
			context "and the value is relatively close"	do
				context "and it could be a time" do
					before(:each) do
						@field.stub(:could_be_a_time?).and_return(true)
					end
					it "returns that it is a datetime" do
						@field.guess_datatype(9.months.ago.to_f).should == "datetime"
					end
				end
				context "but it can't be a time" do
					before(:each) do
						@field.stub(:could_be_a_time?).and_return(false)
					end
					it "returns that it is a integer" do
						@field.guess_datatype(9.months.ago.to_f).should == "float"
					end
				end				
			end
			context "the value is not close to a the curruent unix timestamp" do
				it "returns that it is an integer" do
					@field.guess_datatype(10.32).should == "float"
				end
			end
		end

		context "when input value is an FalseClass or TrueClass type" do
			it "returns that it is a boolean" do
				@field.guess_datatype(true).should == "boolean"
				@field.guess_datatype(false).should == "boolean"
			end
		end
		context "when input value is not a known type" do
			it "returns nil" do
				obj = Object.new
				@field.guess_datatype(obj).should be_nil
			end
		end

		context "when input value is Time or Date" do
			it "returns that it is a datetime" do
				@field.guess_datatype(Time.now).should == "datetime"
				@field.guess_datatype(DateTime.new(2001,2,3)).should == "datetime"
			end
		end
    end

    describe "#could_be_one_of" do

		around(:each) do |example|
			@field = Topic::Field.new(:name => "my Field Name")
			example.run
			@field.could_be_one_of(["at"]).should == true
		end
		it "returns true when key is with underscores" do
			@field.key = "captured_at"
		end
		it "returns true when key is camelcase" do
			@field.key = "capturedAt"
		end
    end

	describe "#could_be_a_time?" do

		it "checks against a list of suffixes" do
			field = Topic::Field.new(:name => "my Field Name")
			field.should_receive(:could_be_one_of).with(["at", "on", "date", "time"])
			field.could_be_a_time?
		end
	end


    describe ".convert" do
		it "converts an integer string to an integer" do
			Topic::Field.convert("123", "integer").should === 123
		end

		it "converts a float string to a float" do
			Topic::Field.convert("123.123", "float").should === 123.123
		end

		it "converts an value to a string" do
			Topic::Field.convert(123.123, "string").should === "123.123"
		end		

		it "converts a boolean string to a boolean" do
			Topic::Field.should_receive(:to_boolean).with("Y").and_return(true)
			Topic::Field.convert("Y", "boolean")
		end
		it "converts a datetime value to a Time" do
			datestring = Time.now.to_s
			Topic::Feed.should_receive(:convert_to_time).with(datestring)
			Topic::Field.convert(datestring, "datetime")
		end	
		it "returns the value if the type is unknown" do
			Topic::Field.convert("xxx", "unknown").should === "xxx"
		end
    end

    describe ".to_boolean" do
		it "converts a value to true" do
			Topic::Field.to_boolean("Y").should === true
			Topic::Field.to_boolean("T").should === true
			Topic::Field.to_boolean("true").should === true
			Topic::Field.to_boolean("TRUE").should === true
			Topic::Field.to_boolean("True").should === true
			Topic::Field.to_boolean("Yes").should === true
			Topic::Field.to_boolean("YES").should === true	
		end
    	it "converts a value to false" do
			Topic::Field.to_boolean("N").should === false
			Topic::Field.to_boolean("F").should === false
			Topic::Field.to_boolean("false").should === false
			Topic::Field.to_boolean("FALSE").should === false
			Topic::Field.to_boolean("False").should === false
			Topic::Field.to_boolean("No").should === false
			Topic::Field.to_boolean("NO").should === false		
    	end		
    end

    describe ".to_number" do
		it "converts the value to Fixnum" do
			Topic::Field.to_number("-123").should == -123
		end
		it "converts the value to Float" do
			Topic::Field.to_number("-123.123").should == -123.123
		end
		it "returns nil if it is not a number" do
			Topic::Field.to_number("asdf").should be_nil
		end
    end

	# [string integer boolean float datetime timezone uri]
    describe "#properties" do
		context "with a string type" do
			before(:each) do
				@field = Topic::Field.new(key: "key", name: "name" , datatype: "string")
			end
			it "returns the hash configuration" do
				@field.properties.should == {type: "string"}
			end
		end

		context "with a timezone type" do
			before(:each) do
				@field = Topic::Field.new(key: "key", name: "name" , datatype: "timezone")
			end			
			it "returns the hash configuration" do
				@field.properties.should == {type: "string", index: "not_analyzed"}
			end
		end

		context "with a uri type" do
			before(:each) do
				@field = Topic::Field.new(key: "key", name: "name" , datatype: "uri")
			end
			it "returns the hash configuration" do
				@field.properties.should == {type: "string", index: "not_analyzed"}
			end
		end

		context "with a lat_long type" do
			before(:each) do
				@field = Topic::Field.new(key: "key", name: "name" , datatype: "lat_long")
			end
			it "returns the hash configuration" do
				@field.properties.should == {type: "geo_point", "fielddata" => {format: "compressed",precision: "1cm"}}
			end
		end

		context "with a ip address type" do
			before(:each) do
				@field = Topic::Field.new(key: "key", name: "name" , datatype: "ip_address")
			end
			it "returns the hash configuration" do
				@field.properties.should == {type: "ip"}
			end
		end		

		context "with a integer type" do
			before(:each) do
				@field = Topic::Field.new(key: "key", name: "name" , datatype: "integer")
			end
			it "returns the hash configuration" do
				@field.properties.should == {type: "integer"}
			end
		end

		context "with a float type" do
			before(:each) do
				@field = Topic::Field.new(key: "key", name: "name" , datatype: "float")
			end
			it "returns the hash configuration" do
				@field.properties.should == {type: "float"}
			end
		end

		context "with a boolean type" do
			before(:each) do
				@field = Topic::Field.new(key: "key", name: "name" , datatype: "boolean")
			end
			it "returns the hash configuration" do
				@field.properties.should == {type: "boolean"}
			end
		end

		context "with a datetime type" do
			before(:each) do
				@field = Topic::Field.new(key: "key", name: "name" , datatype: "datetime")
			end
			it "returns the hash configuration" do
				@field.properties.should == {type: "date", format: "basic_date_time"}
			end
		end
    end

  end
end
