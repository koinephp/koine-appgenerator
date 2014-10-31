ENV["RAILS_ENV"] = "test"

# for some reason it raises in travis env
begin
  # require 'simplecov'
  # SimpleCov.start

  require 'coveralls'
  Coveralls.wear!
rescue LoadError
end

$:.unshift File.dirname(__FILE__)
$:.unshift File.dirname(__FILE__) + '/../lib'

require 'minitest/autorun'

# for some reason it raises in travis env
begin
  require "minitest/reporters"
  # Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new
  # Minitest::Reporters.use! Minitest::Reporters::RspecReporter.new
  Minitest::Reporters.use!
rescue LoadError
end

# require 'mocha/setup'

APP_FOLDER = File.expand_path("../tmp", File.dirname(__FILE__))

# Add support to load paths so we can overwrite broken webrat setup
$:.unshift File.expand_path('../support', __FILE__)
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# For generators
require "rails/generators/test_case"
require "koine-app_generator"
