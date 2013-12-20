# Configure Rails Environment
require 'rake'

ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

load "#{Rails.root.to_s}/db/schema.rb" unless ENV['from_file']

require "rails/test_help"
require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl'
# require 'database_cleaner'
require 'sensit_percolator_api'
require 'json_spec'
Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Dir["#{File.dirname(__FILE__)}/factories/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include ::Sensit::Percolator::Api::Engine.routes.url_helpers
  config.include RequestHelpers, :type => :request
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.around do |example|
      ActiveRecord::Base.transaction do
        example.run
        raise ActiveRecord::Rollback
      end
  end

  config.before(:all) do
    client = ::Elasticsearch::Client.new
    client.indices.create({index: ELASTIC_SEARCH_INDEX_NAME, :body => {:settings => {:index => {:store => {:type => :memory}}}}})
  end

  config.after(:each) do
    client = ::Elasticsearch::Client.new
    client.indices.flush(index: ELASTIC_SEARCH_INDEX_NAME, refresh: true)
  end


  config.after(:all) do
    client = ::Elasticsearch::Client.new
    client.indices.delete(index: ELASTIC_SEARCH_INDEX_NAME)
  end

  # config.before(:suite) do
  #   DatabaseCleaner.strategy = :transaction
  #   DatabaseCleaner.clean_with(:truncation)
  # end

  # config.before(:each) do
  #   DatabaseCleaner.start
  # end

  # config.after(:each) do
  #   DatabaseCleaner.clean
  # end
end