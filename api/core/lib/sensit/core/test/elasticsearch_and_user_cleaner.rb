RSpec.configure do |config|
  config.around do |example|
      ActiveRecord::Base.transaction do
        example.run
        raise ActiveRecord::Rollback
      end
  end

  config.before(:all) do
    @user = Sensit::User.first
    @user = Sensit::User.create(:name => "administrator", :email => "user@example.com", :password => "password", :password_confirmation => "password") if @user.blank?
    ELASTIC_INDEX_NAME = @user.to_param
    @application = Doorkeeper::Application.first
    @application = Doorkeeper::Application.create(name:"Test App", redirect_uri: OAUTH2_REDIRECT_URI, secret: OAUTH2_SECRET, uid: OAUTH2_UID) if @application.blank?
    @access_grant = Doorkeeper::AccessGrant.create(:resource_owner_id => @user.id, :application => @application, :expires_in => 6000000, redirect_uri: OAUTH2_REDIRECT_URI)
    OAUTH2_TOKEN = @access_grant.token
    client = ::Elasticsearch::Client.new

    client.indices.delete({index: ELASTIC_INDEX_NAME}) if client.indices.exists({ index: ELASTIC_INDEX_NAME})
    client.indices.create({index: ELASTIC_INDEX_NAME, :body => {:settings => {:index => {:store => {:type => :memory}}}}})
  end

  # config.before(:each, :type => :request) do
  #   post "/api/sessions", valid_request({name: @user.name, password: @user.password}), valid_session
  # end
  
  config.before(:each) do
    # @user =  Sensit::User.first
  end

  config.after(:each) do
    client = ::Elasticsearch::Client.new
    client.indices.flush(index: @user.to_param, refresh: true)
  end


  config.after(:all) do
    client = ::Elasticsearch::Client.new
    # user =  Sensit::User.first
    client.indices.delete(index: ELASTIC_INDEX_NAME)
    Sensit::User.destroy_all
    # Doorkeeper::Application.destroy_all
    # Doorkeeper::AccessGrant.destroy_all
    # @application.destroy
  end
end