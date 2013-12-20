require 'spec_helper'

describe "settings/email_groups/index", :view => true do
  
  add_load_paths
	ability_authorization
  
  describe "when no email groups exists" do
    before(:each) do
      assign(:search, Ransack::Search.new(EmailGroup))
      assign(:email_groups, Kaminari.paginate_array([]).page(1))
    end
    
    it "displays a message that no email groups exist" do
      render
      assert_select ".none-found-msg", :text => I18n.t("global.none-found-msg", :model => lower_plural_human(EmailGroup))
    end
    
  end
  
  describe "when email_groups exist" do
    before(:each) do
      assign(:search, Ransack::Search.new(EmailGroup))
      assign(:email_groups, Kaminari.paginate_array([
        stub_model(EmailGroup,:name => "email_group_1", :addresses => "foo@bar.com"),
        stub_model(EmailGroup,:name => "email_group_2", :addresses => "foobar@example.com")
      ]).page(1))
    end
    
    it "renders a table of email groups with translated headers" do
      render
      assert_select "table" do
        # assert_select "tr>th", :content => I18n.t("activerecord.attributes.email_group.name"), :count => 1
        # assert_select "tr>th", :content => I18n.t("activerecord.attributes.email_group.addresses"), :count => 1
      end
    end
    
    it "renders a list of email groups" do
      render
      assert_select "table" do
        assert_select "tr>td.name", :content => "Group Name"
        assert_select "tr>td.addresses", :content => "foo@bar.com, bar@foo.com"
      end
    end
    
    it "renders of action buttons new, edit, remove" do
      render
      assert_select "#actions" do
        assert_select ".edit-btn", :content => I18n.t("global.submit-edit"), :count => 1
        assert_select ".remove-btn", :content => I18n.t("global.submit-remove"), :count => 1
      end
    end
    
  end
end
