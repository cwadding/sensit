require "spec_helper"

module Sensit
  describe Nodes::Topics::Feeds::DataController do
        routes { Sensit::Api::Engine.routes }    
    describe "routing" do

      # it "routes to #index" do
      #   get("/nodes/topics").should route_to("nodes/topics#index")
      # end

      # it "routes to #show" do
      #   get("/nodes/topics/1").should route_to("nodes/topics#show", :id => "1")
      # end

      # it "routes to #create" do
      #   post("/nodes/topics").should route_to("nodes/topics#create")
      # end

      # it "routes to #update" do
      #   put("/nodes/topics/1").should route_to("nodes/topics#update", :id => "1")
      # end

      # it "routes to #destroy" do
      #   delete("/nodes/topics/1").should route_to("nodes/topics#destroy", :id => "1")
      # end

    end
  end
end
