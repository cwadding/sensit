require 'spec_helper'

describe "settings/email_groups/show", :view => true do
  
  add_load_paths
	ability_authorization
  
  before(:each) do
    @email_group = stub_model(EmailGroup).as_null_object
    assign(:email_group, @email_group)
  end
  
  # it_should_behave_like  "a template that renders the email_groups/form partial"
  
end
