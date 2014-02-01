require 'spec_helper'

describe "EmailGroups" do
  # index
  describe "GET /settings/emails" do
    it "works! (now write some real specs)" do
      get email_groups_path
      response.status.should be(200)
    end
    
    describe "pagination" do
      context "on page 2 of 4" do
        before(:each) do
          4.times {|i| FactoryGirl.create(:email_group, :name => "email_group#{i+1}")}
          visit email_groups_path(:page => 2, :per => 1)
        end
        it "can navigate to first page" do
          click_link HTMLEntities.new.decode(I18n.t("views.pagination.first"))
          within(".name") {page.should have_content("email_group1")}
          current_url.should == email_groups_url(:per => 1)
        end
        
        it "can navigate to last page" do
          click_link HTMLEntities.new.decode(I18n.t("views.pagination.last"))
          within(".name") {page.should have_content("email_group4")}
          current_url.should == email_groups_url(:page => 4, :per => 1)
        end
        
        it "can navigate to next page" do
          click_link HTMLEntities.new.decode(I18n.t("views.pagination.next"))
          within(".name") { page.should have_content("email_group3") }
          current_url.should == email_groups_url(:page => 3, :per => 1)
        end
        
        it "can navigate to previous page" do
          click_link HTMLEntities.new.decode(I18n.t("views.pagination.previous"))
          within(".name") { page.should have_content("email_group1") }
          current_url.should == email_groups_url(:per => 1)
        end
        
        it "can navigate to a specific page" do
          click_link "3"
          within(".name") { page.should have_content("email_group3") }
          current_url.should == email_groups_url(:page => 3, :per => 1)
        end 
      end
    end

    
    describe "navigation" do
      it "links to a page to add a new email group" do
        visit email_groups_path
        click_link I18n.t("global.new-btn", :model => EmailGroup.model_name.human)
        current_path.should == new_email_group_path
      end
    end
    
    describe "removing an email group" do
      before(:each) do
         FactoryGirl.create(:email_group, :name => "Group Number 1")
         visit email_groups_path
       end
      # it "removes the email group" do
      #   expect {
      #     within "#email_group_1 .destroy" do
      #       click_link("&times;")
      #     end
      #   }.to change(EmailGroup, :count).by(-1)
      #   current_path.should == email_groups_path
      # end
    end
    
    describe "removing multiple email groups" do
      before(:each) do
        4.times {|i| FactoryGirl.create(:email_group, :name => "Group Number #{i+1}")}
        visit email_groups_path
      end      
      it "removes multiple email groups" do
        expect {
          check "check-group-number-1"
          check "check-group-number-2"
          click_button(I18n.t("global.submit-remove"))        
        }.to change(EmailGroup, :count).by(-2)
        current_path.should == email_groups_path
      end
    end
    
  end
  
end
