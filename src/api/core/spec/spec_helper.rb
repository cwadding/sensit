# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'simplecov'
SimpleCov.start 'rails'


load "#{Rails.root.to_s}/db/schema.rb" unless ENV['from_file']

require 'sensit/core'
require "sensit/core/test/all"
require "sensit/core/factories"

Rails.backtrace_cleaner.remove_silencers!

# Load support files

RSpec.configure do |config|
  config.include ::Sensit::Core::Engine.routes.url_helpers
  config.include RequestHelpers, :type => :request
  config.include OAuthHelpers, :type => :request
  config.include OAuthHelpers, :type => :controller
  config.include ::ActionDispatch::TestProcess
  # config.include FactoryGirl::Syntax::Methods
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
