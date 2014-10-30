ENV["RAILS_ENV"] = "test"

$:.unshift File.dirname(__FILE__)
$:.unshift File.dirname(__FILE__) + '/../lib'

require 'minitest/autorun'
# require 'mocha/setup'

APP_FOLDER = File.expand_path("../tmp", File.dirname(__FILE__))

# Add support to load paths so we can overwrite broken webrat setup
$:.unshift File.expand_path('../support', __FILE__)
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# For generators
require "rails/generators/test_case"
require "koine-app_generator"
