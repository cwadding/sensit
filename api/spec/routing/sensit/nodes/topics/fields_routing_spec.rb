require "spec_helper"

module Sensit
  describe Nodes::Topics::FieldsController do
    routes { Sensit::Api::Engine.routes }
    describe "routing" do

      # it "routes to #index" do
      #   get("/api/nodes/1/topics1/fields").should route_to("sensit/fields#index", format: "json")
      # end

      # it "routes to #create" do
      #   post("/api/nodes/1/topics/1/fields").should route_to("sensit/fields#create", format: "json")
      # end

      # it "routes to #show" do
      #   get("/api/nodes/1/topics/1/fields/1").should route_to("sensit/fields#show", :id => "1", format: "json")
      # end      

      # it "routes to #update" do
      #   put("/api/nodes/1/topics/1/fields/1").should route_to("sensit/fields#update", :id => "1", format: "json")
      # end

      # it "routes to #destroy" do
      #   delete("/api/nodes/1/topics/1/fields/1").should route_to("sensit/fields#destroy", :id => "1", format: "json")
      # end

    end
  end
end
