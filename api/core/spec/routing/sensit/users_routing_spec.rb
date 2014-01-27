require "spec_helper"

module Sensit
    describe UsersController do
    routes { Sensit::Core::Engine.routes }
      describe "routing" do

        it "routes to #show" do
          get("/api/user").should route_to("sensit/users#show", format: "json")
        end
      end
    end
end
