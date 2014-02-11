require 'spec_helper'

module Sensit
	module Messenger
		describe "Common" do

			describe "Messenger" do
				context "with http scheme" do
					it "returns a HTTP class" do
						client = Messenger.parse("http://localhost")
						client.should be_an_instance_of(Sensit::Messenger::HTTP)
					end
				end
				context "with mqtt scheme" do
					it "returns a MQTT class" do
						client = Messenger.parse("mqtt://localhost")
						client.should be_an_instance_of(Sensit::Messenger::MQTT)
					end
				end
				context "with tcp scheme" do
					it "returns a TCP class" do
						client = Messenger.parse("tcp://localhost")
						client.should be_an_instance_of(Sensit::Messenger::TCP)
					end
				end
				context "with udp scheme" do
					it "returns a UDP class" do
						client = Messenger.parse("udp://localhost")
						client.should be_an_instance_of(Sensit::Messenger::UDP)
					end
				end
			end

			describe ".scheme_list" do
				it "returns the list of different protocols" do
					scheme_list = Messenger.scheme_list
					scheme_keys = scheme_list.keys
					scheme_values = scheme_list.values
					{"UDP" => UDP, "TCP" => TCP, "HTTP" => HTTP, "MQTT" => MQTT}.each do |key, klass|
						scheme_keys.should include(key)
						scheme_values.should include(klass)
					end
				end
			end
		end
	end
end