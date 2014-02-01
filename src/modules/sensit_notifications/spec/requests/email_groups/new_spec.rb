require 'spec_helper'

describe "EmailGroups" do
  describe "GET /settings/emails/new" do
    it "works! (now write some real specs)" do
      get new_email_group_path
      response.status.should be(200)
    end
    
    describe "creating a new email group" do
    
      context "with valid fields" do
        it "creates a new email group" do
          visit new_email_group_path
          within_fieldset("email_group") do
            fill_in(I18n.t("activerecord.attributes.email_group.name"), :with => "MyEmailGroup")
            fill_in(I18n.t("activerecord.attributes.email_group.addresses"), :with => "asdfas@dfsda.com dafdsfda@dsf.com adsfdas@dsff.com")
          end
          click_button(I18n.t("helpers.submit.create", :model => EmailGroup.model_name.human).to_s)
          email_group = EmailGroup.first
          email_group.name.should == "MyEmailGroup"
          # email_group.should have(3).recipients
          # email_group.recipients.map(&:address).should include("asdfas@dfsda.com", "dafdsfda@dsf.com", "adsfdas@dsff.com")
        end
      end
      
      context "with invalid fields" do
        context "name" do
          it "displays an error with an invalid name"
        end
        context "addresses" do
          # separate email string by commas, semi-colons and whitespace
          it "displays an error with an invalid email"
        end
      end
    
    end
  end
end
