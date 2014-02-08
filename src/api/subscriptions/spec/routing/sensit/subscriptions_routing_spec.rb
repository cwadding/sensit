require "spec_helper"

module Sensit
  describe SubscriptionsController do
    routes { Sensit::Subscriptions::Engine.routes }
    describe "routing" do

      it "routes to #index" do
        get("/api/subscriptions").should route_to("sensit/subscriptions#index", format: "json")
      end

      it "routes to #show" do
        get("/api/subscriptions/1").should route_to("sensit/subscriptions#show", :id => "1", format: "json")
      end

      it "routes to #create" do
        post("/api/subscriptions").should route_to("sensit/subscriptions#create", format: "json")
      end

      it "routes to #update" do
        put("/api/subscriptions/1").should route_to("sensit/subscriptions#update", :id => "1", format: "json")
      end

      it "routes to #destroy" do
        delete("/api/subscriptions/1").should route_to("sensit/subscriptions#destroy", :id => "1", format: "json")
      end

    end
  end
end
