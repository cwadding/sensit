require "spec_helper"

describe Settings::EmailGroupsController do
  describe "routing" do

    it "routes to #index" do
      get("/settings/emails").should route_to("settings/email_groups#index")
    end

    it "routes to #new" do
      get("/settings/emails/new").should route_to("settings/email_groups#new")
    end

    it "routes to #show" do
      get("/settings/emails/1").should route_to("settings/email_groups#show", :id => "1")
    end

    it "routes to #create" do
      post("/settings/emails").should route_to("settings/email_groups#create")
    end

    it "routes to #update" do
      put("/settings/emails/1").should route_to("settings/email_groups#update", :id => "1")
    end
    
    it "routes to #destroy" do
      delete("/settings/emails/1").should route_to("settings/email_groups#destroy", :id => "1")
    end
    
    it "routes to #multiple" do
      put("/settings/emails/multiple").should route_to("settings/email_groups#multiple")
    end

  end
end
