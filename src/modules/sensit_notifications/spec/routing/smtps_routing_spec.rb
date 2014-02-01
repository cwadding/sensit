require "spec_helper"

describe Settings::SmtpController do
  describe "routing" do

    it "routes to #show" do
      get("/settings/smtp").should route_to("settings/smtp#show")
    end

    it "routes to #create" do
      post("/settings/smtp").should route_to("settings/smtp#create")
    end
    
    it "routes to #test" do
      post("/settings/smtp/test").should route_to("settings/smtp#test")
    end

    it "routes to #destroy" do
      delete("/settings/smtp").should route_to("settings/smtp#destroy")
    end

  end
end
