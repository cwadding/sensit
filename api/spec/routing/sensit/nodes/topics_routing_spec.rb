require "spec_helper"

module Sensit
    describe Nodes::TopicsController do
    routes { Sensit::Api::Engine.routes }
      describe "routing" do

        # it "routes to #index" do
        #   get("/api/nodes/1/topics").should route_to(:action => "index", :node_id => "1", format: "json")
        # end

        # it "routes to #create" do
        #   post("/api/nodes/1/topics").should route_to(:action => "create", :node_id => "1", format: "json")
        # end

        # it "routes to #show" do
        #   get("/api/nodes/1/topics/1").should route_to(:action => "show", :id => "1", :node_id => "1", format: "json")
        # end

        # it "routes to #update" do
        #   put("/api/nodes/1/topics/1").should route_to(:action => "update", :id => "1", :node_id => "1", format: "json")
        # end

        # it "routes to #destroy" do
        #   delete("/api/nodes/1/topics/1").should route_to(:controller => "Nodes::TopicsController", :action => "destroy", :id => "1", :node_id => "1", format: "json")
        # end

      end
    end
end
