RSpec.configure do |config|
  config.around do |example|
      ActiveRecord::Base.transaction do
        example.run
        raise ActiveRecord::Rollback
      end
  end

  config.before(:all) do
    Sensit::User.destroy_all
    @user = Sensit::User.create(:name => "test_user", :password => "foobar")
    client = ::Elasticsearch::Client.new
    client.indices.delete index: @user.to_param if client.indices.exists index: @user.to_param
    client.indices.create({index: @user.to_param, :body => {:settings => {:index => {:store => {:type => :memory}}}}})
  end

  config.before(:each, :type => :request) do
    post "/api/sessions", valid_request({name: @user.name, password: @user.password}), valid_session
  end

  config.after(:each) do
    client = ::Elasticsearch::Client.new
    client.indices.flush(index: @user.to_param, refresh: true)
  end


  config.after(:all) do
    client = ::Elasticsearch::Client.new
    client.indices.delete(index: @user.to_param)
    @user.destroy
  end
end