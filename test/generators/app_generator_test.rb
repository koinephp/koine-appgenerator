require_relative '../test_helper'

module Koine
  module Generators
    class AppGeneratorTest < Rails::Generators::TestCase
      destination APP_FOLDER
      tests AppGenerator
      setup :prepare_destination
      arguments ['MyApp']

      test "generates assets" do
        run_generator

        assert_file("MyApp/app/views/layouts/application.html.erb", /stylesheet_link_tag\s+'application', media: 'all', 'data-turbolinks-track' => true/)
        assert_file("MyApp/app/views/layouts/application.html.erb", /javascript_include_tag\s+'application', 'data-turbolinks-track' => true/)
        assert_file("MyApp/app/assets/stylesheets/application.css")
        assert_file("MyApp/app/assets/javascripts/application.js")
      end

      test "skips test unit by default" do
        run_generator

        assert_no_file('MyApp/test')
      end

      test "can be generated withouth rspec" do
        run_generator ['MyApp', '--skip-rspec']

        assert_no_file('MyApp/spec')
      end

      test "installs rspec by default" do
        run_generator

        assert_file(
          'MyApp/Gemfile',
          /gem "rspec-rails", "~> 3.1.0"/,
          /gem "coveralls", require: false/,
          /gem "simplecov", require: false/,
          /gem "database_cleaner"/,
          /gem "shoulda-matchers", require: false/,
          /gem "simplecov", require: false/,
          /gem "timecop"/,
          /gem "webmock"/,
          /gem "machinist"/,
          /gem "spring-commands-rspec"/,
        )

        assert_file('MyApp/spec/rails_helper.rb', /Coveralls/)
        assert_file('MyApp/spec/support/blueprints.rb')
      end

      test "configures generators" do
        run_generator

        assert_file(
          'MyApp/config/application.rb',
          /config.generators do \|generate\|/,
          /generate.decorator false/,
          /generate.helper false/,
          /generate.javascript_engine false/,
          /generate.request_specs false/,
          /generate.routing_specs true/,
          /generate.stylesheets false/,
          /generate.view_specs false/,
          /generate.fixture_replacement :machinist/,
          /generate.test_framework :rspec/
        )
      end
    end
  end
end
