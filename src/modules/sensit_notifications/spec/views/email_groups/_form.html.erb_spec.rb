require 'spec_helper'

describe "settings/email_groups/_form", :view => true do
  include ViewMacros
  add_load_paths
	ability_authorization
  
  before(:each) do
    @email_group = stub_model(EmailGroup).as_null_object
    assign(:email_group, @email_group)
  end
  
  context "when the source is a new record" do
      it "renders a form to create a product_page" do
        render 'form', :email_group => @email_group.as_new_record
        assert_select "form#new_email_group", :method => "post", :action => email_groups_path do |form|
          assert_select "input", :type => "submit"
        end
      end
      
    end
    
    context "when the email group is an existing record" do
      it "renders a form to update a email group" do
        render 'form', :email_group => @email_group
        assert_select "form#edit_email_group_#{@email_group.id}", :method => "post", :action => email_groups_path(@email_group) do |form|
          assert_select "input", :type => "submit"
        end
      end
    end
    
    # it_behaves_like  "a template that renders the shared/page_fields partial", @email_group
    
    # it "renders the form fields for the email_group" do
    #    render 'form', :email_group => @email_group
    #    assert_select "form", :action => email_groups_path(@email_group), :method => "post" do
    #      assert_select "label", :for => "email_group_name", :text => mark_required(EmailGroup, :name), :count => 1
    #      assert_select "input#email_group_name", :count => 1, :type => "text", :name => "email_group[name]"
    #      assert_select "label", :for => "email_group_addresses", :text => I18n.t("activerecord.attributes.email_group.addresses"), :count => 1
    #      assert_select "textarea#email_group_addresses", :count => 1, :name => "email_group[addresses]"
    #    end
    #  end
    #   
end