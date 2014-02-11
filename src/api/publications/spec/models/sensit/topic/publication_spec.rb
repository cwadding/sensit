require 'spec_helper'

module Sensit
	describe Topic::Publication do
		it { should validate_presence_of(:host) }
		it {should belong_to :topic}

		it {should have_many(:percolations).dependent(:destroy)}
		it {should have_many(:rules).through(:percolations)}
		

		describe ".with_action" do
			before(:each) do
				@topic = FactoryGirl.create(:topic, user: @user)
				@publication = FactoryGirl.create(:publication, topic: @topic)
				@publication.actions = ["create", "destroy"]
				@publication.save
			end
			it "returns the publications matching the action" do
				publications = Topic::Publication.with_action("create")

				publications.map(&:id).should include(@publication.id)
			end
		end

		describe ".with_publications", current: true do
			before(:each) do
				@topic = FactoryGirl.create(:topic, user: @user)
				@publication1 = FactoryGirl.create(:publication, topic: @topic)
				@publication1.rules << Sensit::Rule.create(:name => "Rule1")
				rule2 = Sensit::Rule.create(:name => "Rule2")
				@publication1.rules << rule2
				rule3 = Sensit::Rule.create(:name => "Rule3")
				@publication1.rules << rule3
				@publication2 = FactoryGirl.create(:publication, topic: @topic)
				@publication2.rules << rule3
				@publication3 = FactoryGirl.create(:publication, topic: @topic)
				@publication3.rules << rule2
			end
			it "returns the publications matching the action" do
				publications = Topic::Publication.with_percolations(["Rule1", "Rule2"])
				publications.map(&:id).should include(@publication1.id)
				publications.map(&:id).should include(@publication3.id)
			end
		end		


		describe "#actions=" do
			it "sets the bitmask for the actions actions" do
				publication = Topic::Publication.new
				publication.actions = ["create", "destroy"]
				publication.actions_mask.should == 5
			end
		end

		describe "#actions" do
			it "returns the list of actions" do
				publication = Topic::Publication.new
				publication.actions_mask = 5
				publication.actions.should == ["create", "destroy"]
			end
		end	

		describe "#uri=" do
			it "parses the uri and assigns the attributes" do
				publication = ::Sensit::Topic::Publication.new
				publication.uri = "http://user:pass@broker.cloudmqtt.com:1883"
				publication.username.should == "user"
				publication.password.should == "pass"
				publication.protocol.should == "http"
				publication.host.should == "broker.cloudmqtt.com"
				publication.port.should == 1883
			end
		end
		describe "#uri" do
			it "with authentication" do
				publication = ::Sensit::Topic::Publication.new(protocol: "http", username: "user", password: "pass", host: "broker.cloudmqtt.com", port: 1883)
				publication.uri.should == "http://user:pass@broker.cloudmqtt.com:1883"
			end
			it "without authentication" do
				publication = ::Sensit::Topic::Publication.new(protocol: "http", host: "broker.cloudmqtt.com", port: 1883)
				publication.uri.should == "http://broker.cloudmqtt.com:1883"
			end			
		end	

		describe "#client" do
			context "with blower.io protocol (SMS)" do
				before(:each) do
					@publication = ::Sensit::Topic::Publication.new(protocol: "blower.io")
				end
				it "blower.io" do
					client = @publication.client
					client.should be_an_instance_of(::Sensit::Messenger::HTTP)
					client.uri.should == 'http://localhost:80/messages?'
				end
			end
			context "with an unknown protocol" do
				before(:each) do
					@publication = ::Sensit::Topic::Publication.new(protocol: "dsgfdgfd")
				end
				it "returns nil" do
					client = @publication.client
					client.should be_nil
				end
			end
			context "with http protocol" do
				before(:each) do
					@publication = ::Sensit::Topic::Publication.new(protocol: "http")
					@publication.stub(:uri).and_return("http://localhost")
				end
				it "calls publish on the client" do
					@publication.client.should be_an_instance_of(::Sensit::Messenger::HTTP)
				end
			end
			context "with tcp protocol" do
				before(:each) do
					@publication = ::Sensit::Topic::Publication.new(protocol: "tcp")
					@publication.stub(:uri).and_return("tcp://localhost")
				end
				it "calls publish on the client" do
					@publication.client.should be_an_instance_of(::Sensit::Messenger::TCP)
				end
			end

			context "with udp protocol" do
				before(:each) do
					@publication = ::Sensit::Topic::Publication.new(protocol: "udp")
					@publication.stub(:uri).and_return("tcp://localhost")
				end
				it "calls publish on the client" do
					@publication.client.should be_an_instance_of(::Sensit::Messenger::UDP)
				end
			end

			context "with mqtt protocol" do
				before(:each) do
					@publication = ::Sensit::Topic::Publication.new(protocol: "mqtt")
					@publication.stub(:uri).and_return("mqtt://localhost")
				end
				it "calls publish on the client" do
					@publication.client.should be_an_instance_of(::Sensit::Messenger::MQTT)
				end			
			end
		end

		describe "#publish"	do
			context "with blower.io protocol (SMS)" do
				before(:each) do
					@publication = ::Sensit::Topic::Publication.new(protocol: "blower.io", topic_id: "1")
				end
				it "calls publish on the client" do
					http = ::Sensit::Messenger::HTTP.new
					http.should_receive(:publish).with(1, {to: '+14155550000', message: "message"})
					@publication.stub(:client).and_return(http)
					@publication.publish("message")
				end
			end

			context "with http protocol" do
				before(:each) do
					@publication = ::Sensit::Topic::Publication.new(protocol: "http", topic_id: "1")
				end
				it "calls publish on the client" do
					http = ::Sensit::Messenger::HTTP.new
					http.should_receive(:publish).with(1, "message")
					@publication.stub(:client).and_return(http)
					@publication.publish("message")
				end
			end			
		end
	end
end
