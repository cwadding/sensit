require "spec_helper"

module Sensit
  describe PublicationsController do
    routes { Sensit::Publications::Engine.routes }
    describe "routing" do

      it "routes to #index" do
        get("/api/topics/1/publications").should route_to("sensit/publications#index", format: "json", topic_id: "1")
      end

      it "routes to #show" do
        get("/api/topics/1/publications/1").should route_to("sensit/publications#show", :id => "1", format: "json", topic_id: "1")
      end

      it "routes to #create" do
        post("/api/topics/1/publications").should route_to("sensit/publications#create", format: "json", topic_id: "1")
      end

      it "routes to #update" do
        put("/api/topics/1/publications/1").should route_to("sensit/publications#update", :id => "1", format: "json", topic_id: "1")
      end

      it "routes to #destroy" do
        delete("/api/topics/1/publications/1").should route_to("sensit/publications#destroy", :id => "1", format: "json", topic_id: "1")
      end

    end
  end
end
