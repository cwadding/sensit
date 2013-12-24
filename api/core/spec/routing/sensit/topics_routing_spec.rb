require "spec_helper"

module Sensit
    describe TopicsController do
    routes { Sensit::Core::Engine.routes }
      describe "routing" do

        it "routes to #index" do
          get("/api/topics").should route_to("sensit/topics#index",   format: "json")
        end

        it "routes to #create" do
          post("/api/topics").should route_to("sensit/topics#create",   format: "json")
        end

        it "routes to #show" do
          get("/api/topics/1").should route_to("sensit/topics#show",  :id => "1",  format: "json")
        end

        it "routes to #update" do
          put("/api/topics/1").should route_to("sensit/topics#update",  :id => "1",  format: "json")
        end

        it "routes to #destroy" do
          delete("/api/topics/1").should route_to("sensit/topics#destroy", :id => "1",  format: "json")
        end

      end
    end
end
