require 'spec_helper'

describe "EmailGroups" do  
  describe "GET /settings/emails/:id" do
    before(:each) do
      @email_group = FactoryGirl.create(:email_group)
    end
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get email_group_path(@email_group)
      response.status.should be(200)
    end
    describe "updating an existing email group" do
      context "with valid fields" do
        # it "updates a new email group" do
        #   visit email_group_path(@email_group)
        #   expect {
        #     within_fieldset("email_group") do
        #       fill_in(I18n.t("activerecord.attributes.email_group.name"), :with => "MyEmailGroup")
        #       fill_in(I18n.t("activerecord.attributes.email_group.addresses"), :with => "asdfas@dfsda.com dafdsfda@dsf.com adsfdas@dsff.com")
        #     end
        #     click_button(I18n.t("helpers.submit.update", :model => EmailGroup.model_name.human).to_s)            
        #   }.to change(@email_group, :count).by(3)
        # 
        #   email_group = EmailGroup.find(@email_group.id)
        #   email_group.name.should eql("MyEmailGroup")
        #   email_group.recipients.map(&:address).should include("asdfas@dfsda.com", "dafdsfda@dsf.com", "adsfdas@dsff.com")
        # end
      end
    end    
  end
  
end
