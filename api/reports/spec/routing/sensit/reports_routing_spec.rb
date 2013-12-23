require "spec_helper"

module Sensit
  describe ReportsController do
    routes { Sensit::Reports::Engine.routes }
    describe "routing" do

      it "routes to #index" do
        get("/api/topics/1/reports").should route_to("sensit/reports#index", :topic_id => "1", format: "json")
      end

      it "routes to #show" do
        get("/api/topics/1/reports/1").should route_to("sensit/reports#show", :topic_id => "1", :id => "1", format: "json")
      end

      it "routes to #create" do
        post("/api/topics/1/reports").should route_to("sensit/reports#create", :topic_id => "1", format: "json")
      end

      it "routes to #update" do
        put("/api/topics/1/reports/1").should route_to("sensit/reports#update", :topic_id => "1", :id => "1", format: "json")
      end

      it "routes to #destroy" do
        delete("/api/topics/1/reports/1").should route_to("sensit/reports#destroy", :topic_id => "1", :id => "1", format: "json")
      end

    end
  end
end
