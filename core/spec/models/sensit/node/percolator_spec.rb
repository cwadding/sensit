require 'spec_helper'

module Sensit
  describe Node::Percolator do
    it { should validate_presence_of(:id) }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:type) }

    before(:each) do
        @client = ::Elasticsearch::Client.new log: true
    end

    describe ".count" do
        context "when the index exists" do
            it "executes the elastic count query" do                
                @client.should_receive(:count).with({index: "_percolator", type: "atm"}).and_return({"count"=>4, "_shards"=>{"total"=>1, "successful"=>1, "failed"=>0}})
                Node::Percolator.stub(:elastic_client).and_return(@client)
                total = Node::Percolator.count({type: "atm"})
            end
            it "returns the number of rows" do
                @client.stub(:count).with({index: "_percolator", type: "atm"}).and_return({"count"=>36, "_shards"=>{"total"=>5, "successful"=>5, "failed"=>0}})
                Node::Percolator.stub(:elastic_client).and_return(@client)
                total = Node::Percolator.count({type: "atm"})
                total.should == 36
            end
        end
    end

    describe ".find" do
        context "with valid params" do
            context "when the record exists" do
                before(:each) do
                    @params = {type: "atm", id: "myrule", body: { query: { query_string: { query: 'foo' } } } }
                    @result1 = {"_index"=>"_percolator", "_type"=>"atm", "_id"=>"myrule", "_score"=>1.0, "_source"=>{"query"=>{"query_string"=>{"query"=>"foo"}}}}
                end
                it "executes the elastic get query" do
                    @client.should_receive(:get).with(@params.merge!(index: "_percolator")).and_return(@result1)

                    Node::Percolator.stub(:elastic_client).and_return(@client)
                    percolator = Node::Percolator.find(@params.merge!(index: "_percolator"))
                end
                it "returns the percolator" do
                    @client.stub(:get).and_return(@result1)
                    Node::Percolator.stub(:elastic_client).and_return(@client)
                    percolator = Node::Percolator.find(@params)
                    percolator.should be_an_instance_of Node::Percolator
                end
            end
            context "when the record doesn't exist" do
                before(:each) do
                    @params = {type: "atm", id: 'cOsusCVJQUabbfZcIdDyAg' }
                    @client.stub(:get).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
                end
                it "throws an exception that it is not found" do
                    Node::Percolator.stub(:elastic_client).and_return(@client)
                    expect{
                        Node::Percolator.find(@params)
                    }.to raise_error(::Elasticsearch::Transport::Transport::Errors::NotFound)
                end
            end
        end
        context "with invalid params" do
            before(:each) do
                @params = {type: "fsd", id: 'cOsusCVJQUabbfZcIdDyAg' }
                @client.stub(:get).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
            end
            it "throws an exception that it is not found" do
                Node::Percolator.stub(:elastic_client).and_return(@client)
                expect{
                    Node::Percolator.find(@params)
                }.to raise_error(::Elasticsearch::Transport::Transport::Errors::NotFound)
            end             
        end
    end

    describe ".create" do
        before(:each) do
            @params = {type: 'mytype', id: "myrule", body: { query: { query_string: { query: 'foo' } } } }
            @percolator = Node::Percolator.new(@params)
        end
        it "executes the create instance" do
            @percolator.should_receive(:create).and_return(true)
            Node::Percolator.should_receive(:new).with(@params.merge!(index: "_percolator")).and_return(@percolator)
            percolator = Node::Percolator.create(@params)
        end

        it "returns a Percolator" do
            @percolator.stub(:create).and_return(true)
            Node::Percolator.stub(:new).with(@params.merge!(index: "_percolator")).and_return(@percolator)
            percolator = Node::Percolator.create(@params)
            percolator.should be(@percolator)
        end
    end

    describe ".search" do
        before(:each) do
            @params =  {type: 'mytype' }
            @result1 = {"_index"=>"_percolator","_type"=>"mytype","_id"=>"vVHkzUTuThOTpl-tstkzhg","_score"=>1.0, "_source" => { "query" => { "query_string" => { "query" => 'foo' } } }}
            @result2 = {"_index"=>"_percolator","_type"=>"mytype","_id"=>"1ZiRp7VHSHK_-3NmoJjusQ","_score"=>1.0, "_source" => { "query" => { "query_string" => { "query" => 'foo' } } }}
            @results = {"took" => 2,"timed_out" => false, "_shards" => {"total" => 5,"successful" => 5,"failed" => 0},"hits" => {"total"=>2,"max_score"=>1.0,"hits"=>[@result1,@result2]}}
        end
        it "executes the elastic search query" do
            @client.should_receive(:search).with(@params.merge!(index: "_percolator")).and_return(@results)
            Node::Percolator.stub(:elastic_client).and_return(@client)
            percolators = Node::Percolator.search(@params)
        end

        it "returns an array of Feeds" do
            @client.stub(:search).and_return(@results)
            Node::Percolator.should_receive(:map_results).with(@result1).and_return(Node::Percolator.new)
            Node::Percolator.should_receive(:map_results).with(@result2).and_return(Node::Percolator.new)

            Node::Percolator.stub(:elastic_client).and_return(@client)

            percolators = Node::Percolator.search(@params)

            percolators.should be_an_instance_of Array
            percolators.each do |percolator|
                percolator.should be_an_instance_of Node::Percolator
            end
        end
    end

    describe ".destroy" do
        before(:each) do
            @params = {type: 'mytype', id: '1'}
        end
        context "when the record exists" do
            it "executes the elastic delete" do
                @client.should_receive(:delete).with(@params.merge!(index: "_percolator")).and_return({"ok"=>true, "found"=>true, "_index"=>"transactions", "_type"=>"atm", "_id"=>"8eI2kKfwSymCrhqkjnGYiA", "_version"=>4})
                Node::Percolator.stub(:elastic_client).and_return(@client)
                Node::Percolator.destroy(@params)
            end
        end
        context "when the record does not exist" do
            it "throws an exception that it is not found" do
                @client.stub(:delete).with(@params.merge!(index: "_percolator")).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
                Node::Percolator.stub(:elastic_client).and_return(@client)
                expect{
                    Node::Percolator.destroy(@params)
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
                @indices_client.should_receive(:delete).with({index: "_percolator", :type => "my_type"}).and_return({"ok"=>true, "acknowledged"=>true})
                @client.stub(:indices).and_return(@indices_client)
                Node::Percolator.stub(:elastic_client).and_return(@client)
                Node::Percolator.destroy_all({:type => "my_type"})
            end
        end
        context "when the index does not exist" do
            it "throws an exception that it is not found" do
                @indices_client.should_receive(:delete).with({index: "_percolator", :type => "my_type"}).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
                @client.stub(:indices).and_return(@indices_client)
                Node::Percolator.stub(:elastic_client).and_return(@client)
                expect{
                    Node::Percolator.destroy_all({index: "_percolator", :type => "my_type"})
                }.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
            end
        end
    end 


    describe "#create" do


        before(:each) do
            @indices_client = Elasticsearch::API::Indices::IndicesClient.new(@client)
            @percolator = Node::Percolator.new({type: 'mytype', id: 'myrule', body: { query: { query_string: { query: 'foo' } } } })
            # @params = {index: 'myindex', type: 'mytype', topic_id: 3, at: Time.now, values: {title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}}
            # {index: 'myindex',type: 'mytype', body: {title: 'Test 1',tags: ['y', 'z'], published: true, published_at: Time.now.utc.iso8601, counter: 1}}
        end
        # context "when the index doesn't exist (called for first time)" do
        #   before(:each) do
        #       @indices_client.stub(:exists).and_return(false)
        #   end
        #   it "creates the index" do
        #       @indices_client.should_receive(:create)
        #       @client.stub(:indices).and_return(@indices_client)
        #       Node::Percolator.stub(:elastic_client).and_return(@client)
        #       percolator = Node::Percolator.create(@params)
        #   end

        # end
        context "when the index does exist" do
            before(:each) do
                @indices_client.stub(:exists).and_return(true)
            end
            context "with valid response" do
                it "executes the elastic create action" do
                    @client.should_receive(:create).with({index: "_percolator", :type=>"mytype", id: 'myrule', :body=>{ query: { query_string: { query: 'foo' } } }}).and_return({"ok"=>true, "_index"=>'_percolator', "_type"=>'mytype', "_id"=>"myrule", "_version"=>1})
                    Node::Percolator.stub(:elastic_client).and_return(@client)
                    @percolator.send(:create)
                end
                context "" do
                    before(:each) do
                        @client.stub(:create).and_return({"ok"=>true, "_index"=>'_percolator', "_type"=>'mytype', "_id"=>"myrule", "_version"=>1})
                        Node::Percolator.stub(:elastic_client).and_return(@client)
                    end

                    it "returns whether it was successful" do
                        success = @percolator.send(:create)
                        success.should be_true
                    end

                    it "is no longer a new record" do
                        @percolator.send(:create)
                        @percolator.should_not be_a_new_record
                    end 
                end
            end
        end     
    end

    describe "#update" do
        before(:each) do
            @percolator = Node::Percolator.new({type: 'mytype', id: 3, body: {query: { query_string: { query: 'foo' } } }})
            @percolator.stub(:id).and_return(3)
            @percolator.stub(:new_record?).and_return(false)
        end
        it "executes the update class action" do
            @client.should_receive(:update).with({index: "_percolator", type: 'mytype', id: 3, body:{ doc:{ query: { query_string: { query: 'foo' } }}}}).and_return({"ok"=>true, "_index"=>'_percolator', "_type"=>'mytype', "_id"=>"myrule", "_version"=>1})
            @percolator.stub(:elastic_client).and_return(@client)
            success = @percolator.send(:update)
        end

        it "returns true when update is successful" do
            @client.stub(:update).and_return({"ok"=>true, "_index"=>"_percolator", "_type"=>"atm", "_id"=>"myrule", "_version"=>3})
            @percolator.stub(:elastic_client).and_return(@client)
            success = @percolator.send(:update)
            success.should be_true
        end 
    end 



    describe "#destroy" do
        before(:each) do
            @percolator = Node::Percolator.new({type: 'mytype',  id: 3, body: {query: { query_string: { query: 'foo' } } }})
        end
        context "when the record is not a new record" do
            before(:each) do
                @percolator.stub(:new_record?).and_return(false)
            end
            it "executes the elastic delete" do
                Node::Percolator.should_receive(:destroy).with({index: "_percolator", type: 'mytype', id: 3}).and_return(true)
                @percolator.destroy.should be_true
            end
        end
        context "when the record is a new record" do
            it "throws an exception that it is not found" do
                expect{
                    @percolator.destroy
                }.to raise_error(Elasticsearch::Transport::Transport::Errors::BadRequest)
            end
        end
    end 

    describe "#save" do
        before(:each) do
            @percolator = Node::Percolator.new({type: 'mytype',  id: 3, body: {query: { query_string: { query: 'foo' } } } })
        end
        context "when the record is not a new record" do
            before(:each) do
                @percolator.stub(:new_record?).and_return(false)
            end
            it "updates the record" do
                @percolator.should_receive(:update).and_return(true)
                @percolator.save
            end
        end
        context "when the record is a new record" do
            before(:each) do
                @percolator.stub(:new_record?).and_return(true)
            end
            it "creates the record" do
                @percolator.should_receive(:create).and_return(true)
                @percolator.save
            end
        end     
    end    
  end
end
