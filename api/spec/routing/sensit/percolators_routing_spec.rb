require "spec_helper"

module Sensit
  describe PercolatorsController do
    routes { Sensit::Api::Engine.routes }
    describe "routing" do

      it "routes to #index" do
        get("/api/nodes/1/topics/1/percolators").should route_to("sensit/percolators#index", :node_id => "1", :topic_id => "1", format: "json")
      end
 
      it "routes to #show" do
        get("/api/nodes/1/topics/1/percolators/1").should route_to("sensit/percolators#show", :node_id => "1", :topic_id => "1", :id => "1", format: "json")
      end

      it "routes to #create" do
        post("/api/nodes/1/topics/1/percolators").should route_to("sensit/percolators#create", :node_id => "1", :topic_id => "1", format: "json")
      end

      it "routes to #update" do
        put("/api/nodes/1/topics/1/percolators/1").should route_to("sensit/percolators#update", :node_id => "1", :topic_id => "1", :id => "1", format: "json")
      end

      it "routes to #destroy" do
        delete("/api/nodes/1/topics/1/percolators/1").should route_to("sensit/percolators#destroy", :node_id => "1", :topic_id => "1", :id => "1", format: "json")
      end

    end
  end
end
