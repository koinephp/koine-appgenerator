require 'coveralls'
Coveralls.wear!

$:.unshift File.dirname(__FILE__)
$:.unshift File.dirname(__FILE__) + '/../lib'

require 'minitest/autorun'
require "minitest/focus"

require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new
# Minitest::Reporters.use! Minitest::Reporters::RspecReporter.new
# Minitest::Reporters.use!

# require 'mocha/setup'

APP_FOLDER = File.expand_path("../tmp", File.dirname(__FILE__))

# Add support to load paths so we can overwrite broken webrat setup
$:.unshift File.expand_path('../support', __FILE__)
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# For generators
require "rails/generators/test_case"
require "koine-app_generator"

module TestHelper
  def assert_not_in_file(content, file)
    assert_file file

    absolute = File.expand_path(file, destination_root)
    assert !File.read(absolute).match(content), "Failed asserting that file #{absolute} does not contain #{content}"
  end

  def assert_gem(gemname, version = nil)
    if version
      assert_file 'MyApp/Gemfile', /gem "#{gemname}", "#{version}"/
    else
      assert_file 'MyApp/Gemfile', /gem "#{gemname}"/
    end
  end
end
