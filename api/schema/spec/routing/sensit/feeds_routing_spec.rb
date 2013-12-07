require "spec_helper"

module Sensit
    describe FeedsController do
        routes { Sensit::Schema::Api::Engine.routes }
      describe "routing" do

        it "routes to #create" do
          post("/api/topics/1/feeds").should route_to("sensit/feeds#create",  :topic_id => "1", format: "json")
        end

        it "routes to #show" do
          get("/api/topics/1/feeds/1").should route_to("sensit/feeds#show", :id => "1",  :topic_id => "1", :id => "1", format: "json")
        end

        it "routes to #update" do
          put("/api/topics/1/feeds/1").should route_to("sensit/feeds#update", :id => "1",  :topic_id => "1", :id => "1", format: "json")
        end

        it "routes to #destroy" do
          delete("/api/topics/1/feeds/1").should route_to("sensit/feeds#destroy", :id => "1",  :topic_id => "1", :id => "1", format: "json")
        end

      end
    end
end
