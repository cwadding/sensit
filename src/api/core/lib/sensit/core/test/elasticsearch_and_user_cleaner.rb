RSpec::Runner.configure do |config|
  config.before(:all) do
    if ENV['ELASTICSEARCH_URL']
      @client = ::Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'])
    else
      @client = ::Elasticsearch::Client.new
    end
    @client.indices.delete({index: ELASTIC_INDEX_NAME}) if @client.indices.exists({ index: ELASTIC_INDEX_NAME})
    @client.indices.create({index: ELASTIC_INDEX_NAME, :body => {:settings => {:index => {:store => {:type => :memory}}}}})
  end
  config.after(:each) do
    @client = ::Elasticsearch::Client.new
    @client.indices.flush(index: ELASTIC_INDEX_NAME, refresh: true)
  end
  config.after(:all) do
    @client = ::Elasticsearch::Client.new
    @client.indices.delete(index: ELASTIC_INDEX_NAME)
  end
end

RSpec.configure do |config|
  config.around do |example|
      ActiveRecord::Base.transaction do
        example.run
        raise ActiveRecord::Rollback
      end
  end

  config.before(:each) do
    @user = Sensit::User.create(:name => ELASTIC_INDEX_NAME, :email => "user@example.com", :password => "password", :password_confirmation => "password")
  end

  # config.before(:each, :type => :request) do
  #   post "/api/sessions", valid_request({name: @user.name, password: @user.password}), valid_session
  # end
end