# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

load "#{Rails.root.to_s}/db/schema.rb" unless ENV['from_file']

require 'sensit/core'
require "sensit/core/test/all"
require "sensit/core/factories"

Rails.backtrace_cleaner.remove_silencers!


OAUTH2_UID = "e072c008ab1f1c99b91a503f8e038836e1e5451f843c5443f29eccc27f1a7d63"
OAUTH2_SECRET = "95b63199f75e780fb787549a9551582878181afd15db19c3835daafb6a265ca6"
OAUTH2_TOKEN = "my_token"
OAUTH2_REDIRECT_URI = "http://localhost:8080/oauth2/callback"
ELASTIC_INDEX_NAME = ""

# Load support files

RSpec.configure do |config|
  config.include ::Sensit::Core::Engine.routes.url_helpers
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
    config.fixture_path = "#{File.dirname(__FILE__)}/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    # config.use_transactional_fixtures = false

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false
end
