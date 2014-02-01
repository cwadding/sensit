require 'spec_helper'

module Sensit
  describe Topic::Percolator do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:query) }
    it { should validate_presence_of(:topic_id) }
    it { should validate_presence_of(:user_id) }

    before(:each) do
        if ENV['ELASTICSEARCH_URL']
            @client = ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'])
        else
            @client = ::Elasticsearch::Client.new
        end        
    end

    describe ".count" do
        context "when the index exists" do
            it "executes the elastic count query" do                
                @client.should_receive(:count).with({index: ELASTIC_INDEX_NAME, type: "#{@user.name}:atm"}).and_return({"count"=>4, "_shards"=>{"total"=>1, "successful"=>1, "failed"=>0}})
                Topic::Percolator.stub(:elastic_client).and_return(@client)
                total = Topic::Percolator.count({topic_id: 'atm', user_id: @user.name})
            end
            it "returns the number of rows" do
                @client.stub(:count).with({index: ELASTIC_INDEX_NAME, type: "#{@user.name}:atm"}).and_return({"count"=>36, "_shards"=>{"total"=>5, "successful"=>5, "failed"=>0}})
                Topic::Percolator.stub(:elastic_client).and_return(@client)
                total = Topic::Percolator.count({topic_id: 'atm', user_id: @user.name})
                total.should == 36
            end
        end
    end

    describe ".find" do
        context "with valid params" do
            context "when the record exists" do
                before(:each) do
                    @params = {topic_id: 'atm', user_id: @user.name, name: "myrule", query: { query: { query_string: { query: 'foo' } } } }
                    @result1 = {"_index"=>@user.name, "_type"=>"atm", "_id"=>"myrule", "_score"=>1.0, "_source"=>{"query"=>{"query_string"=>{"query"=>"foo"}}}}
                end
                it "executes the elastic get query" do
                    @client.should_receive(:get).with({index: ELASTIC_INDEX_NAME, type: "#{@params[:user_id]}:#{@params[:topic_id]}", id:@params[:name], query: { query: { query_string: { query: 'foo' } } }}).and_return(@result1)

                    Topic::Percolator.stub(:elastic_client).and_return(@client)
                    percolator = Topic::Percolator.find(@params.merge!(index: ELASTIC_INDEX_NAME))
                end
                it "returns the percolator" do
                    @client.stub(:get).and_return(@result1)
                    Topic::Percolator.stub(:elastic_client).and_return(@client)
                    percolator = Topic::Percolator.find(@params)
                    percolator.should be_an_instance_of Topic::Percolator
                end
            end
            context "when the record doesn't exist" do
                before(:each) do
                    @params = {topic_id: 'atm', user_id: @user.name, name: 'cOsusCVJQUabbfZcIdDyAg' }
                    @client.stub(:get).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
                end
                it "throws an exception that it is not found" do
                    Topic::Percolator.stub(:elastic_client).and_return(@client)
                    expect{
                        Topic::Percolator.find(@params)
                    }.to raise_error(::Elasticsearch::Transport::Transport::Errors::NotFound)
                end
            end
        end
        context "with invalid params" do
            before(:each) do
                @params = {topic_id: "fsd", user_id: @user.name , name: 'cOsusCVJQUabbfZcIdDyAg' }
                @client.stub(:get).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
            end
            it "throws an exception that it is not found" do
                Topic::Percolator.stub(:elastic_client).and_return(@client)
                expect{
                    Topic::Percolator.find(@params)
                }.to raise_error(::Elasticsearch::Transport::Transport::Errors::NotFound)
            end             
        end
    end

    describe ".create" do
        before(:each) do
            @params = {topic_id: 'mytype', user_id: @user.name, name: "myrule", query: { query: { query_string: { query: 'foo' } } } }
            @percolator = Topic::Percolator.new(@params)
        end
        it "executes the create instance" do
            @percolator.should_receive(:create).and_return(true)
            Topic::Percolator.should_receive(:new).with(@params.merge!(index: ELASTIC_INDEX_NAME)).and_return(@percolator)
            percolator = Topic::Percolator.create(@params)
        end

        it "returns a Topic::Percolator" do
            @percolator.stub(:create).and_return(true)
            Topic::Percolator.stub(:new).with(@params.merge!(index: ELASTIC_INDEX_NAME)).and_return(@percolator)
            percolator = Topic::Percolator.create(@params)
            percolator.should be(@percolator)
        end
    end

    describe ".search" do
        before(:each) do
            @params =  {topic_id: 'mytype', user_id: @user.name }
            @result1 = {"_index"=>@user.name,"_type"=>"mytype","_id"=>"vVHkzUTuThOTpl-tstkzhg","_score"=>1.0, "_source" => { "query" => { "query_string" => { "query" => 'foo' } } }}
            @result2 = {"_index"=>@user.name,"_type"=>"mytype","_id"=>"1ZiRp7VHSHK_-3NmoJjusQ","_score"=>1.0, "_source" => { "query" => { "query_string" => { "query" => 'foo' } } }}
            @results = {"took" => 2,"timed_out" => false, "_shards" => {"total" => 5,"successful" => 5,"failed" => 0},"hits" => {"total"=>2,"max_score"=>1.0,"hits"=>[@result1,@result2]}}
        end
        it "executes the elastic search query" do
            @client.should_receive(:search).with(@params.merge!({index: ELASTIC_INDEX_NAME, type: "#{@params[:user_id]}:#{@params[:topic_id]}"})).and_return(@results)
            Topic::Percolator.stub(:elastic_client).and_return(@client)
            percolators = Topic::Percolator.search(@params)
        end

        it "returns an array of Feeds" do
            @client.stub(:search).and_return(@results)
            Topic::Percolator.should_receive(:map_results).with(@result1).and_return(Topic::Percolator.new)
            Topic::Percolator.should_receive(:map_results).with(@result2).and_return(Topic::Percolator.new)

            Topic::Percolator.stub(:elastic_client).and_return(@client)

            percolators = Topic::Percolator.search(@params)

            percolators.should be_an_instance_of Array
            percolators.each do |percolator|
                percolator.should be_an_instance_of Topic::Percolator
            end
        end
    end

    describe ".destroy" do
        before(:each) do
            @params = {topic_id: 'mytype', user_id: @user.name, name: '1'}
        end
        context "when the record exists" do
            it "executes the elastic delete" do
                @client.should_receive(:delete).with({index: ELASTIC_INDEX_NAME, type: "#{@params[:user_id]}:#{@params[:topic_id]}", id: @params[:name] }).and_return({"ok"=>true, "found"=>true, "_index"=>"transactions", "_type"=>"atm", "_id"=>"8eI2kKfwSymCrhqkjnGYiA", "_version"=>4})
                Topic::Percolator.stub(:elastic_client).and_return(@client)
                Topic::Percolator.destroy(@params)
            end
        end
        context "when the record does not exist" do
            it "throws an exception that it is not found" do
                @client.stub(:delete).with({index: ELASTIC_INDEX_NAME, type: "#{@params[:user_id]}:#{@params[:topic_id]}", id: @params[:name] }).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
                Topic::Percolator.stub(:elastic_client).and_return(@client)
                expect{
                    Topic::Percolator.destroy(@params)
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
                @indices_client.should_receive(:delete).with({index: ELASTIC_INDEX_NAME, :type => "#{@user.name}:my_type"}).and_return({"ok"=>true, "acknowledged"=>true})
                @client.stub(:indices).and_return(@indices_client)
                Topic::Percolator.stub(:elastic_client).and_return(@client)
                Topic::Percolator.destroy_all({:topic_id => "my_type", :user_id => @user.name})
            end
        end
        context "when the index does not exist" do
            it "throws an exception that it is not found" do
                @indices_client.should_receive(:delete).with({index: ELASTIC_INDEX_NAME, :type => "#{@user.name}:my_type"}).and_raise(::Elasticsearch::Transport::Transport::Errors::NotFound)
                @client.stub(:indices).and_return(@indices_client)
                Topic::Percolator.stub(:elastic_client).and_return(@client)
                expect{
                    Topic::Percolator.destroy_all({user_id: @user.name, :topic_id => "my_type"})
                }.to raise_error(Elasticsearch::Transport::Transport::Errors::NotFound)
            end
        end
    end 


    describe "#create" do


        before(:each) do
            @indices_client = Elasticsearch::API::Indices::IndicesClient.new(@client)
            @percolator = Topic::Percolator.new({topic_id: 'mytype', user_id: @user.name, name: 'myrule', query: { query: { query_string: { query: 'foo' } } } })
            # @params = {index: 'myindex', topic_id: 'mytype', user_id: @user.name, topic_name: 3, at: Time.now, values: {title: 'Test 1',tags: ['y', 'z'], published: true, counter: 1}}
            # {index: 'myindex',topic_id: 'mytype', user_id: @user.name, body: {title: 'Test 1',tags: ['y', 'z'], published: true, published_at: Time.now.utc.iso8601, counter: 1}}
        end
        # context "when the index doesn't exist (called for first time)" do
        #   before(:each) do
        #       @indices_client.stub(:exists).and_return(false)
        #   end
        #   it "creates the index" do
        #       @indices_client.should_receive(:create)
        #       @client.stub(:indices).and_return(@indices_client)
        #       Topic::Percolator.stub(:elastic_client).and_return(@client)
        #       percolator = Topic::Percolator.create(@params)
        #   end

        # end
        context "when the index does exist" do
            before(:each) do
                @indices_client.stub(:exists).and_return(true)
            end
            context "with valid response" do
                it "executes the elastic create action" do
                    @client.should_receive(:create).with({index: ELASTIC_INDEX_NAME, :type => "#{@user.name}:mytype", id: 'myrule', :body=>{ query: { query_string: { query: 'foo' } } }}).and_return({"ok"=>true, "_index"=>'_percolator', "_type"=>'mytype', "_id"=>"myrule", "_version"=>1})
                    Topic::Percolator.stub(:elastic_client).and_return(@client)
                    @percolator.send(:create)
                end
                context "" do
                    before(:each) do
                        @client.stub(:create).and_return({"ok"=>true, "_index"=>'_percolator', "_type"=>'mytype', "_id"=>"myrule", "_version"=>1})
                        Topic::Percolator.stub(:elastic_client).and_return(@client)
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
            @percolator = Topic::Percolator.new({topic_id: 'mytype', user_id: @user.name, name: 3, query: {query: { query_string: { query: 'foo' } } }})
            @percolator.stub(:id).and_return(3)
            @percolator.stub(:new_record?).and_return(false)
        end
        it "executes the update class action" do
            @client.should_receive(:update).with({index: ELASTIC_INDEX_NAME, type: "#{@user.name}:mytype", id: 3, body:{ doc:{ query: { query_string: { query: 'foo' } }}}}).and_return({"ok"=>true, "_index"=>'_percolator', "_type"=>'mytype', "_id"=>"myrule", "_version"=>1})
            @percolator.stub(:elastic_client).and_return(@client)
            success = @percolator.send(:update)
        end

        it "returns true when update is successful" do
            @client.stub(:update).and_return({"ok"=>true, "_index"=> @user.name, "_type"=>"atm", "_id"=>"myrule", "_version"=>3})
            @percolator.stub(:elastic_client).and_return(@client)
            success = @percolator.send(:update)
            success.should be_true
        end 
    end 



    describe "#destroy" do
        before(:each) do
            @percolator = Topic::Percolator.new({topic_id: 'mytype', user_id: @user.name,  name: 3, query: {query: { query_string: { query: 'foo' } } }})
        end
        context "when the record is not a new record" do
            before(:each) do
                @percolator.stub(:new_record?).and_return(false)
            end
            it "executes the elastic delete" do
                Topic::Percolator.should_receive(:destroy).with({user_id: @user.name, topic_id: "mytype", name: 3}).and_return(true)
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
            @percolator = Topic::Percolator.new({topic_id: 'mytype', user_id: @user.name,  name: 3, query: {query: { query_string: { query: 'foo' } } } })
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
