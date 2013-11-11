require "spec_helper"

module Sensit
    describe NodesController do
    routes { Sensit::Api::Engine.routes }

      describe "routing" do
        it "routes to #index" do
          get("/api/nodes").should route_to("sensit/nodes#index", format: "json")
        end

        it "routes to #show" do
          get("/api/nodes/1").should route_to("sensit/nodes#show", :id => "1", format: "json")
        end

        it "routes to #create" do
          post("/api/nodes").should route_to("sensit/nodes#create", format: "json")
        end

        it "routes to #update" do
          put("/api/nodes/1").should route_to("sensit/nodes#update", :id => "1", format: "json")
        end

        it "routes to #destroy" do
          delete("/api/nodes/1").should route_to("sensit/nodes#destroy", :id => "1", format: "json")
        end

      end
    end
end
