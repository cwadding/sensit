RSpec.configure do |config|
  config.around do |example|
      ActiveRecord::Base.transaction do
        example.run
        raise ActiveRecord::Rollback
      end
  end

  config.before(:each) do
    @user = Sensit::User.create(:name => "username", :email => "user@example.com", :password => "password", :password_confirmation => "password")
  end

  # config.before(:each, :type => :request) do
  #   post "/api/sessions", valid_request({name: @user.name, password: @user.password}), valid_session
  # end
end