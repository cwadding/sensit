require "spec_helper"

module Sensit
  describe PercolatorsController do
    routes { Sensit::Percolator::Api::Engine.routes }
    describe "routing" do

      it "routes to #index" do
        get("/api/topics/1/percolators").should route_to("sensit/percolators#index",  :topic_id => "1", format: "json")
      end
 
      it "routes to #show" do
        get("/api/topics/1/percolators/1").should route_to("sensit/percolators#show",  :topic_id => "1", :id => "1", format: "json")
      end

      it "routes to #create" do
        post("/api/topics/1/percolators").should route_to("sensit/percolators#create",  :topic_id => "1", format: "json")
      end

      it "routes to #update" do
        put("/api/topics/1/percolators/1").should route_to("sensit/percolators#update",  :topic_id => "1", :id => "1", format: "json")
      end

      it "routes to #destroy" do
        delete("/api/topics/1/percolators/1").should route_to("sensit/percolators#destroy",  :topic_id => "1", :id => "1", format: "json")
      end

    end
  end
end
