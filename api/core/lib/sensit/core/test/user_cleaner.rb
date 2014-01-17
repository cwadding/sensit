RSpec.configure do |config|
  config.before(:all) do
    Sensit::User.destroy_all
    @user = Sensit::User.create(:name => "test_user", :password => "foobar")
  end

  config.before(:each, :type => :request) do
    post "/api/sessions", valid_request({name: @user.name, password: @user.password}), valid_session
  end

  config.after(:all) do
    @user.destroy
  end
end