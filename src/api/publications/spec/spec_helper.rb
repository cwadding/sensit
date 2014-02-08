# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'simplecov'
SimpleCov.start 'rails'

load "#{Rails.root.to_s}/db/schema.rb" unless ENV['from_file']

OAUTH2_REDIRECT_URI = "http://localhost:8080/oauth2/callback"
ELASTIC_INDEX_NAME = "my_index"

require 'sensit_publications'
require "sensit/core/test/dependencies"
require "sensit/core/test/request_helpers"
require "sensit/core/test/oauth_helpers"
require "sensit/core/test/user_cleaner"
require "sensit/core/factories"

Rails.backtrace_cleaner.remove_silencers!


Dir["#{File.dirname(__FILE__)}/factories/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include ::Sensit::Publications::Engine.routes.url_helpers
  config.include RequestHelpers, :type => :request
  config.include OAuthHelpers, :type => :request
  config.include OAuthHelpers, :type => :controller
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
end