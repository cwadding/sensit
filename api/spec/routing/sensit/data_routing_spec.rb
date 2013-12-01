require "spec_helper"

module Sensit
  describe DataController do
        routes { Sensit::Api::Engine.routes }    
    describe "routing" do

      it "routes to #show" do
        get("/api/topics/1/feeds/1/data/1").should route_to("sensit/data#show", :id => "1",  :topic_id => "1",  :feed_id => "1", :id => "1", format: "json")
      end

      it "routes to #update" do
        put("/api/topics/1/feeds/1/data/1").should route_to("sensit/data#update", :id => "1",  :topic_id => "1", :feed_id => "1", :id => "1",  format: "json")
      end

    end
  end
end
