module ControllerMacros
  # def login_admin
  #   before(:each) do
  #     sign_out :user
  #     sign_in FactoryGirl.create(:user)
  #   end
  # end
  
  def login_user
    before(:each) do
      sign_out :user
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      # user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the confirmable module
      sign_in user
    end
  end
  
  
    
end

shared_examples_for "a controller with DELETE destroy" do
  before(:each) do
    controller.stub(:flash_notice).with(@factory, "destroy").and_return("flash message for destroy")
  end
  it "destroys the requested model" do
    expect {
      delete :destroy, {:id => @factory.to_param}, valid_session
    }.to change(@factory.class, :count).by(-1)
  end

  it "redirects to the index url" do
    delete :destroy, {:id => @factory.to_param}, valid_session
    if defined?(@redirect)
      response.should redirect_to(@redirect)
    else
      response.should redirect_to({"controller"=>controller.params[:controller], "action"=>"index"})
    end
  end

  it "returns a flash message that says that the model has been destroyed" do
    delete :destroy, {:id => @factory.to_param}, valid_session
    controller.flash[:notice].should eql("flash message for destroy")
  end
end