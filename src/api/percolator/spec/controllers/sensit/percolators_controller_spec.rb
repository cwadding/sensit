require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

module Sensit
    describe PercolatorsController do

      before(:each) do
        @access_grant = FactoryGirl.create(:access_grant, resource_owner_id: @user.id, scopes: "read_any_percolations manage_any_percolations")
        controller.stub(:doorkeeper_token).and_return(@access_grant)
        @topic = FactoryGirl.create(:topic, name:"topic_type", application: @access_grant.application, user:@user)
      end

      
      def valid_request(h = {})
        h.merge!({:use_route => :sensit_percolator, :format => "json", :topic_id => "topic_type", :api_version => 1})
      end
      # This should return the minimal set of attributes required to create a valid
      # ::Sensit::Topic::Percolator. As you add validations to ::Sensit::Topic::Percolator, be sure to
      # update the return value of this method accordingly.
      def valid_attributes(h={})
        { :topic_id => "topic_type", name: "3", query: { query: { query_string: { query: 'foo' } } } }.merge!(h)
      end

      # This should return the minimal set of values that should be in the session
      # in order to pass any filters (e.g. authentication) defined in
      # ::Sensit::PercolatorsController. Be sure to keep this updated too.
      def valid_session(params = {})
        {}.merge!(params)
      end

      describe "GET show" do
        it "assigns the requested percolator as @percolator" do
          percolator = ::Sensit::Topic::Percolator.create valid_attributes(user_id: @user.name, topic_id: @topic.to_param)
          get :show, valid_request(:id => percolator.name), valid_session(user_id: @user.name)
          assigns(:percolator).name.should eq(percolator.name)
        end
      end

      describe "POST create" do
        describe "with valid params" do
          it "creates a new ::Sensit::Topic::Percolator" do
            if ENV['ELASTICSEARCH_URL']
              client = ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'])
            else
              client = ::Elasticsearch::Client.new
            end
            expect {
              post :create, valid_request(:percolator => { topic_id: "topic_type", user_id: @user.name, :name => "mytest1", :query => {query: { query_string: { query: 'foo' } } }}), valid_session(user_id: @user.name)
              client.indices.refresh(index: ELASTIC_INDEX_NAME)
            }.to change{::Sensit::Topic::Percolator.count({ topic_id: "topic_type", user_id: @user.name})}.by(1)
          end

          it "assigns a newly created percolator as @percolator" do
            post :create, valid_request(:percolator => {  topic_id: "topic_type", user_id: @user.name, :name => "mytest2", :query => {query: { query_string: { query: 'foo' } } } }), valid_session(user_id: @user.name)
            assigns(:percolator).should be_a(::Sensit::Topic::Percolator)
            # assigns(:percolator).should_not be_a_new_record
          end

          it "renders to the created percolator" do
            post :create, valid_request(:percolator => { topic_id: "topic_type", user_id: @user.name, :name => "mytest3", :query => {query: { query_string: { query: 'foo' } } } }), valid_session(user_id: @user.name)
            response.should render_template("sensit/percolators/show")
          end
        end

        describe "with invalid params" do
          it "assigns a newly created but unsaved percolator as @percolator" do
            # Trigger the behavior that occurs when invalid params are submitted
            ::Sensit::Topic::Percolator.any_instance.stub(:save).and_return(false)
            post :create, valid_request(:percolator => { topic_id: "topic_type", user_id: @user.name, :name => "mytest", :query => {query: { query_string: { query: 'foo' } } }  }), valid_session(user_id: @user.name)
            assigns(:percolator).should be_a_new(::Sensit::Topic::Percolator)
          end

          it "re-renders the 'new' template" do
            # Trigger the behavior that occurs when invalid params are submitted
            ::Sensit::Topic::Percolator.any_instance.stub(:save).and_return(false)
            post :create, valid_request(:percolator => { topic_id: "topic_type", user_id: @user.name, :name => "mytest", :query => {query: { query_string: { query: 'foo' } } }  }), valid_session(user_id: @user.name)
            response.status.should == 422
          end
        end
      end

      describe "PUT update" do
        before(:each) do
          @percolator = ::Sensit::Topic::Percolator.new valid_attributes(user_id: @user.name, name:4, topic_id: @topic.to_param)
        end
        describe "with valid params" do
          it "updates the requested percolator" do
            ::Sensit::Topic::Percolator.should_receive(:update).with({"name" => @percolator.name, "topic_id" => @percolator.topic_id, "user_id" => @user.name, "query" => {"query" => { "query_string" => { "query" => 'foo' } } }  }).and_return(@percolator)
            put :update, valid_request(:id => @percolator.name, :percolator => { :query => {query: { query_string: { query: 'foo' } } }  }), valid_session(user_id: @user.name)
          end

          it "assigns the requested percolator as @percolator" do
            ::Sensit::Topic::Percolator.stub(:update).with({"name" => @percolator.name, "topic_id" => @percolator.topic_id, "user_id" => @user.name, "query" => {"query" => { "query_string" => { "query" => 'foo' } } }  }).and_return(@percolator)
            put :update, valid_request(:id => @percolator.name, :percolator => { :query => {query: { query_string: { query: 'foo' } } }  }), valid_session(user_id: @user.name)
            assigns(:percolator).name.should == @percolator.name
          end

          it "renders the percolator" do
            ::Sensit::Topic::Percolator.stub(:update).with({"name" => @percolator.name, "topic_id" => @percolator.topic_id, "user_id" => @user.name, "query" => {"query" => { "query_string" => { "query" => 'foo' } } }  }).and_return(@percolator)
            put :update, valid_request(:id => @percolator.name, :percolator => { :query => {query: { query_string: { query: 'foo' } } }  }), valid_session(user_id: @user.name)
            response.should render_template("sensit/percolators/show")
          end
        end

        describe "with invalid params" do
          it "assigns the percolator as @percolator" do
            # Trigger the behavior that occurs when invalid params are submitted
            @percolator.stub(:valid?).and_return(false)
            ::Sensit::Topic::Percolator.should_receive(:update).with({"name" => @percolator.name, "topic_id" => @percolator.topic_id, "user_id" => @user.name, "query" => {"query" => { "query_string" => { "query" => 'foo' } } }  }).and_return(@percolator)
            put :update, valid_request(:id => @percolator.name, :percolator => { :query => {query: { query_string: { query: 'foo' } } }  } ), valid_session(user_id: @user.name)
            assigns(:percolator).name.should == @percolator.name
          end

          it "re-renders the 'edit' template" do
            # Trigger the behavior that occurs when invalid params are submitted
            @percolator.stub(:valid?).and_return(false)
            ::Sensit::Topic::Percolator.should_receive(:update).with({"name" => @percolator.name, "topic_id" => @percolator.topic_id, "user_id" => @user.name, "query" => {"query" => { "query_string" => { "query" => 'foo' } } }  }).and_return(@percolator)

            put :update, valid_request(:id => @percolator.name, :percolator => { :query => {query: { query_string: { query: 'foo' } } }  } ), valid_session(user_id: @user.name)
            response.status.should == 422
          end
        end
      end

      describe "DELETE destroy" do
        before(:each) do
          @percolator = ::Sensit::Topic::Percolator.create valid_attributes(user_id: @user.name, name:9, topic_id: @topic.to_param)
        end
        it "destroys the requested percolator" do
          if ENV['ELASTICSEARCH_URL']
            client = ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'])
          else
            client = ::Elasticsearch::Client.new
          end
          client.indices.refresh(index: ELASTIC_INDEX_NAME)
          expect {
            delete :destroy, valid_request(:id => @percolator.name), valid_session(user_id: @user.name)
            client.indices.refresh(index: ELASTIC_INDEX_NAME)
          }.to change{::Sensit::Topic::Percolator.count({topic_id: "topic_type", user_id: @user.name})}.by(-1)
        end

        it "redirects to the percolators list" do
          delete :destroy, valid_request(:id => @percolator.name), valid_session(user_id: @user.name)
          response.status.should == 204
        end
      end

      describe ".percolator_params" do
        after(:each) do
          @new_params.should == controller.params[:percolator]
        end
        context "match queries" do
          context "boolean type" do
            # it "no properties" do
            #   controller.params = {percolator: {name: 1, query:{query: {match: {message: "this is a test"}}}}}
            #   @new_params = controller.send(:percolator_params)
            # end
            it "with operator and minimum_should_match" do
              controller.params = {percolator: {name: 1, query:{query: {match: {message: {query: "this is a test", operator: "and", minimum_should_match: 1, zero_terms_query: "all", cutoff_frequency: 0.0001}}}}}}
              @new_params = controller.send(:percolator_params)
            end
          end
          context "phrase type" do
            # it "no properties" do
            #   controller.params = {percolator: {name: 1, query:{query: {match_phrase: {message: "this is a test"}}}}}
            #   @new_params = controller.send(:percolator_params)
            # end
            it "with analyzer" do
              controller.params = {percolator: {name: 1, query:{query: {match_phrase: {message: {query: "this is a test", analyzer:"my_analyzer"}}}}}}
              @new_params = controller.send(:percolator_params)
            end
            it "specifying type" do
              controller.params = {percolator: {name: 1, query:{query: {match: {message: {query: "this is a test", type: "phrase"}}}}}}
              @new_params = controller.send(:percolator_params)
            end
          end
          context "match phrase prefix type" do
            # it "no properties" do
            #   controller.params = {percolator: {name: 1, query:{query: {match_phrase_prefix: {message: "this is a test"}}}}}
            #   @new_params = controller.send(:percolator_params)
            # end
            it "with max_expansions" do
              controller.params = {percolator: {name: 1, query:{query: {match_phrase_prefix: {message: {query: "this is a test", max_expansions:10}}}}}}
              @new_params = controller.send(:percolator_params)
            end
            it "specifying type" do
              controller.params = {percolator: {name: 1, query:{query: {match: {message: {query: "this is a test", type: "phrase_prefix"}}}}}}
              @new_params = controller.send(:percolator_params)
            end
          end   
        end

        context "multi_match queries" do
            it "default" do
              controller.params = {percolator: {name: 1, query:{query: {multi_match: {query: "this is a test", fields: ["subject", "message"]}}}}}
              @new_params = controller.send(:percolator_params)
            end
            it "with use_dis_max" do
              controller.params = {percolator: {name: 1, query:{query: {multi_match: {query: "this is a test", fields: ["subject", "message"], use_dis_max: true}}}}}
              @new_params = controller.send(:percolator_params)
            end
        end

        context "bool queries" do
            it "default" do
              controller.params = {percolator: {name: 1, query:{query: {"bool" => { "must" => { "term" => { "user" => "kimchy" } }, "must_not" => { "range" => { "age" => { "from" => 10, "to" => 20 } } }, "should" => [{"term" => { "tag" => "wow" }},{"term" => { "tag" => "elasticsearch" }}],"minimum_should_match" => 1}}}}}
              @new_params = controller.send(:percolator_params)
            end
            it "common term alternative" do
              controller.params = {percolator: {name: 1, query:{query: {"bool"=> { "must"=> [ { "term"=> { "body"=> "nelly"}}, { "term"=> { "body"=> "elephant"}}, { "term"=> { "body"=> "cartoon"}}],"should"=> [{ "term"=> { "body"=> "the"}}, { "term"=> { "body"=> "as"}},{ "term"=> { "body"=> "a"}}], "minimum_should_match"=> 2}}}}}
              @new_params = controller.send(:percolator_params)
            end

        end


        context "common queries" do
            it "default" do
              controller.params = {percolator: {name: 1, query:{query: {"common" => {"body" => {"query" => "nelly the elephant as a cartoon", "cutoff_frequency" => 0.001, "low_freq_operator" => "and", "minimum_should_match"=> 2}}}}}}
              @new_params = controller.send(:percolator_params)
            end
            it "minimum_should_match with low and high freq" do
              controller.params = {percolator: {name: 1, query:{query: {"common" => {"body" => {"query" => "nelly the elephant as a cartoon", "cutoff_frequency" => 0.001, "low_freq_operator" => "and", "minimum_should_match"=> {"low_freq" => 2, "high_freq" => 3}}}}}}}
              @new_params = controller.send(:percolator_params)
            end
        end

        context "dis max queries" do
            it "default" do
              controller.params = {percolator: {name: 1, query:{query: { "dis_max" => {"tie_breaker" => 0.7, "queries" => [{"term" => { "age" => 34 }}, { "term" => { "age" => 35 }}]}}}}}
              @new_params = controller.send(:percolator_params)
            end
        end
        
        context "match_all query" do
            it "default" do
              controller.params = {percolator: {name: 1, query:{query: {"match_all" => {}}}}}
              @new_params = controller.send(:percolator_params)
            end
        end

        context "prefix query" do
            # it "default" do
            #   controller.params = {percolator: {name: 1, query:{query: {"prefix" => { "user" => "ki" }}}}}
            #   @new_params = controller.send(:percolator_params)
            # end
            it "long form" do
              controller.params = {percolator: {name: 1, query:{query: {"prefix" => { "user" => {"prefix" => "ki"} }}}}}
              @new_params = controller.send(:percolator_params)
            end            
        end     

        
        context "query_string query" do
            it "default_field" do
              controller.params = {percolator: {name: 1, query:{query: {"query_string" => { "default_field" => "content", "query" => "this AND that OR thus", "default_operator" => "OR", "allow_leading_wildcard" => true }}}}}
              @new_params = controller.send(:percolator_params)
            end
            it "multi_field" do
              controller.params = {percolator: {name: 1, query:{query: {"query_string" => { "fields" => ["content", "name"], "query" => "this AND that OR thus", "use_dis_max" => true }}}}}
              @new_params = controller.send(:percolator_params)
            end       
        end

        context "range query" do
            it "gte and lte" do
              controller.params = {percolator: {name: 1, query:{query: {"range" => {"age" => {"gte" => 10,"lte" => 20}}}}}}
              @new_params = controller.send(:percolator_params)
            end
            it "gt and lt" do
              controller.params = {percolator: {name: 1, query:{query: {"range" => {"age" => {"gt" => 10,"lt" => 20}}}}}}
              @new_params = controller.send(:percolator_params)
            end  
        end

        context "span first query" do
            it "default" do
              controller.params = {percolator: {name: 1, query:{query: {"span_first" => {"match" => {"span_term" => { "user" => "kimchy" }},"end" => 3}}}}}
              @new_params = controller.send(:percolator_params)
            end
        end  

        context "span-multi query" do
            it "default" do
              controller.params = {percolator: {name: 1, query:{query: {"span_multi" => {"match" => {"prefix" => { "user" =>  { "value" => "ki" } }}}}}}}
              @new_params = controller.send(:percolator_params)
            end
        end

        context "span-near query" do
            it "default" do
              controller.params = {percolator: {name: 1, query:{query: {"span_near" => {"clauses" => [{ "span_term" => { "field" => "value1" } },{ "span_term" => { "field" => "value2" } },{ "span_term" => { "field" => "value3" } }],"slop" => 12,"in_order" => false,"collect_payloads" => false}}}}}
              @new_params = controller.send(:percolator_params)
            end
        end


        context "span-not query" do
            it "default" do
              controller.params = {percolator: {name: 1, query:{query: {"span_not" => {"include" => {"span_term" => { "field1" => "value1" }},"exclude" => {"span_term" => { "field2" => "value2" }}}}}}}
              @new_params = controller.send(:percolator_params)
            end
        end 

        context "span-or query" do
            it "default" do
              controller.params = {percolator: {name: 1, query:{query: {"span_or" => {"clauses" => [{ "span_term" => { "field" => "value1" } },{ "span_term" => { "field" => "value2" } },{ "span_term" => { "field" => "value3" } }]}}}}}
              @new_params = controller.send(:percolator_params)
            end
        end

        context "span-term query" do
            # it "default" do
            #   controller.params = {percolator: {name: 1, query:{query: {"span_term" => { "user" => "kimchy" }}}}}
            #   @new_params = controller.send(:percolator_params)
            # end

            it "long form" do
              controller.params = {percolator: {name: 1, query:{query: {"span_term" => { "user" => { "term" => "kimchy"} }}}}}
              @new_params = controller.send(:percolator_params)
            end            
        end          

        context "term queries" do
          it "with key value pairs" do
            controller.params = {percolator: {name: 1, query:{query: {term: {user: "kimchy"}}}}}
            @new_params = controller.send(:percolator_params)
          end

          it "with a key and a value" do
            controller.params = {percolator: {name: 1, query:{query: {term: {user: {value: "kimchy"}}}}}}
            @new_params = controller.send(:percolator_params)
          end
        end

        context "terms queries" do
          it "with array of values" do
            controller.params = {percolator: {name: 1, query:{query: {terms: {tags: [ "blue", "pill" ], minimum_should_match: 1}}}}}
            @new_params = controller.send(:percolator_params)
          end

          it "with array of values using `in` alias" do
            controller.params = {percolator: {name: 1, query:{query: {in: {tags: [ "blue", "pill" ], minimum_should_match: 1}}}}}
            @new_params = controller.send(:percolator_params)
          end
        end

      end

    end
end

