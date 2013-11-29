require "spec_helper"

module Sensit
  describe FieldsController do
    routes { Sensit::Api::Engine.routes }
    describe "routing" do

      it "routes to #index" do
        get("/api/topics/1/fields").should route_to("sensit/fields#index",  :topic_id => "1", format: "json")
      end

      it "routes to #create" do
        post("/api/topics/1/fields").should route_to("sensit/fields#create",  :topic_id => "1", format: "json")
      end

      it "routes to #show" do
        get("/api/topics/1/fields/1").should route_to("sensit/fields#show",  :topic_id => "1",:id => "1", format: "json")
      end      

      it "routes to #update" do
        put("/api/topics/1/fields/1").should route_to("sensit/fields#update",  :topic_id => "1",:id => "1", format: "json")
      end

      it "routes to #destroy" do
        delete("/api/topics/1/fields/1").should route_to("sensit/fields#destroy",  :topic_id => "1",:id => "1", format: "json")
      end

    end
  end
end
