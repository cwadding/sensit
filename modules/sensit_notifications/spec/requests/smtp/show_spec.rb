require 'spec_helper'

describe "Smtps" do
  describe "GET /settings_smtp" do
    it "works! (now write some real specs)" do
      get smtp_path
      response.status.should == 200
    end
  end
  
  def valid_params
    {:domain => "foobar@gmail.com", :address => "smtp.gmail.com", :port => "123"}
  end
  
  def fill_out_form
    fill_in I18n.t("simple_form.labels.smtp.domain"), :with => "foobar@gmail.com"
    fill_in I18n.t("simple_form.labels.smtp.address"), :with => "smtp.gmail.com"
    fill_in I18n.t("simple_form.labels.smtp.port"), :with => "123"
    fill_in I18n.t("simple_form.labels.smtp.username"), :with => "myusername"
    fill_in I18n.t("simple_form.labels.smtp.password"), :with => "password"
    fill_in I18n.t("simple_form.labels.smtp.password_confirmation"), :with => "password"
  end
  
  def assert_database_updated(smtp)
    smtp.domain.should == "foobar@gmail.com"
    smtp.address.should == "smtp.gmail.com"
    smtp.port.should == "123"
    smtp.username.should == "myusername"
  end

  describe "adding the smtp settings" do
    before(:each) do
        visit smtp_path
    end
    after(:each) do
        Smtp.destroy
    end
      
  	context "without user name and password" do
      # TODO make it so password digest is not required
      # it "sets the smtp information" do
      #   fill_in I18n.t("simple_form.labels.smtp.domain"), :with => "foobar@gmail.com"
      #   fill_in I18n.t("simple_form.labels.smtp.address"), :with => "smtp.gmail.com"
      #   fill_in I18n.t("simple_form.labels.smtp.port"), :with => "123"
      #   click_button I18n.t("helpers.submit.create", :model => Smtp.model_name.human)
      #   smtp = Smtp.new
      #   smtp.domain.should == "foobar@gmail.com"
      #   smtp.address.should == "smtp.gmail.com"
      #   smtp.port.should == "123"
      # end
  	end

  	context "with username and password" do
      # it "sets the smtp information" do
      #         fill_out_form
      #         click_button I18n.t("helpers.submit.create", :model => Smtp.model_name.human)
      #         smtp = Smtp.new
      #         smtp.domain.should == "foobar@gmail.com"
      #         smtp.address.should == "smtp.gmail.com"
      #         smtp.port.should == "123"
      #       end
  	end

  end

  describe "clearing the smtp settings" do
    before(:each) do
      # smtp = FactoryGirl.stub(:smtp)
      smtp = Smtp.new(valid_params)
      smtp.save
      visit smtp_path
    end

    # it "removes the smtp information" do
    #   find_field(I18n.t("simple_form.labels.smtp.domain")).value.should_not be_blank
    #   find_field(I18n.t("simple_form.labels.smtp.address")).value.should_not be_blank
    #   click_link I18n.t("global.link-to-clear", :model => Smtp.model_name.human)
    #   find("input#smtp_domain").value.should be_blank
    #   find("input#smtp_address").value.should be_blank
    # end
  end
end
