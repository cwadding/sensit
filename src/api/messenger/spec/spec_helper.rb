require 'rubygems'
require 'bundler/setup'

require 'simplecov'
SimpleCov.start do
	add_group "lib", "lib"
	add_group "specs", "spec"
end

require 'sensit_messenger' # and any other gems you need

RSpec.configure do |config|
  # some (optional) config here
end