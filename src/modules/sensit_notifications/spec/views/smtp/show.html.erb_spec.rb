require 'spec_helper'

describe "settings/smtp/show", :view => true do
  
  add_load_paths
	ability_authorization
  
  describe "as new" do
    before(:each) do
      assign(:smtp, stub_model(Smtp).as_new_record)
    end
      
    it "renders the new smtp form" do
      render
      assert_select "form#new_smtp", :action => smtp_path, :method => "post" do
        assert_select "input", :type => "submit"
      end
    end

    it "renders the form fields for the smtp" do
       render
       assert_select "form", :method => "post" do |form|
         assert_select "input#smtp_address", :name => "smtp[address]", :type => 'text'
         assert_select "input#smtp_port", :name => "smtp[port]", :type => 'text'
         assert_select "input#smtp_username", :name => "smtp[username]", :type => 'text'
         assert_select "input#smtp_password", :name => "smtp[password]", :type => 'passsword'
         assert_select "input#smtp_password_confirmation", :name => "smtp[password_confirmation]", :type => 'password'
         assert_select "input#smtp_domain", :name => "smtp[domain]", :type => 'text'
       end
     end
  end
  
  describe "as edit" do
     before(:each) do
       @smtp = assign(:smtp, stub_model(Smtp))
     end

     it "renders the edit smtp form" do
       render
       assert_select "form#edit_smtp_" + @smtp.id.to_s, :action => smtp_path(@smtp), :method => "post" do
         assert_select "input", :type => "submit"
       end
     end
   end
   
      
end
