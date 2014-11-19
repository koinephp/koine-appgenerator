require_relative '../test_helper'

module Koine
  module Generators
    class AppGeneratorTest < Rails::Generators::TestCase
      include TestHelper

      destination APP_FOLDER
      tests AppGenerator
      setup :prepare_destination
      arguments ['MyApp']

      test "generates assets" do
        run_generator

        assert_file("MyApp/app/views/layouts/application.html.erb")
        assert_no_file("MyApp/app/assets/stylesheets/application.css")
        assert_file("MyApp/app/assets/stylesheets/application.css.scss")
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

        assert_file('MyApp/.rspec')
        assert_file('MyApp/spec/rails_helper.rb')
        assert_file('MyApp/spec/spec_helper.rb')
        assert_file('MyApp/spec/support/blueprints.rb')

        assert_file('MyApp/spec/rails_helper.rb', /require 'capybara\/rspec'/)

        assert_file('MyApp/spec/rails_helper.rb', /Capybara/)
        assert_file('MyApp/spec/rails_helper.rb', /start 'rails'/)
        assert_file('MyApp/.gitignore', /coveralls/)
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

      test "copy files" do
        run_generator

        assert_no_file "MyApp/README.rdoc"
        assert_file "MyApp/README.md", /MyApp/
        assert_file "MyApp/.travis.yml", /MyApp_test/
        # assert_file "MyApp/.coveralls.yml"
      end

      test "removes turbolink" do
        run_generator

        assert_not_in_file 'turbolinks',  'MyApp/app/assets/javascripts/application.js'
        assert_not_in_file 'turbolinks',  'MyApp/Gemfile'
      end

      test "adds high voltage gem" do
        run_generator

        assert_gem 'high_voltage', '~> 2.2.1'
      end

      test "sets home page" do
        run_generator

        assert_file "MyApp/app/views/pages/home.html.erb", /Hello World!/
        assert_file "MyApp/app/controllers/pages_controller.rb"
        assert_file "MyApp/spec/controllers/pages_controller_spec.rb"

        assert_file 'MyApp/config/routes.rb', /root to: "pages#show", id: "home"/
      end

      test "removes routes comment" do
        run_generator

        assert_not_in_file "# ", 'MyApp/config/routes.rb'
      end

      test "configures smtp" do
        run_generator

        assert_file 'MyApp/config/initializers/smtp_initializer.rb'
        assert_file 'MyApp/config/smtp.yml'
        assert_file 'MyApp/config/smtp.yml.dist'
        assert_file 'MyApp/.gitignore', /config\/smtp.yml/
      end

      test "configures action mail host" do
        run_generator
        app_name = 'MyApp'

        assert_file 'MyApp/config/environments/development.rb', /#{app_name}\.local/
        assert_file 'MyApp/config/environments/test.rb', /www\.example\.com/
        assert_file 'MyApp/config/environments/staging.rb', /staging\.#{app_name}\.com/
        assert_file 'MyApp/config/environments/production.rb', /#{app_name}\.com/
      end

      test "configures staging environment" do
        run_generator

        assert_file 'MyApp/config/environments/staging.rb', /MyApp::Application.configure do/
      end

      test "installs draper gem" do
        run_generator

        assert_gem 'draper', '~> 1.3'
      end

      test "raises delivery errors on development" do
        run_generator

        assert_file 'MyApp/config/environments/development.rb', /raise_delivery_errors = true/
      end

      test "raises on unpermitted params in test and development environments" do
        run_generator

        assert_file 'MyApp/config/environments/development.rb', /action_on_unpermitted_parameters = :raise/
        assert_file 'MyApp/config/environments/test.rb', /action_on_unpermitted_parameters = :raise/
      end

      test "customizes error pages" do
        run_generator

        assert_file 'MyApp/public/404.html', /ROBOTS/, /NOODP/
        assert_file 'MyApp/public/422.html', /ROBOTS/, /NOODP/
        assert_file 'MyApp/public/500.html', /ROBOTS/, /NOODP/
      end

      test "configure default time zone" do
        run_generator

        assert_file 'MyApp/config/application.rb', /config.active_record.default_timezone = :utc/
      end

      test "copies the localization files" do
        run_generator

        assert_file 'MyApp/config/locales/en.yml', /with_weekday/
        assert_file 'MyApp/config/locales/pt-BR.yml'
        assert_file 'MyApp/config/locales/devise.en.yml'
        assert_file 'MyApp/config/locales/devise.pt-BR.yml'
        assert_file 'MyApp/config/locales/system.pt-BR.yml'
      end

      test "installs zurb foundation" do
        run_generator

        assert_gem 'foundation-rails'
        assert_file 'MyApp/app/assets/stylesheets/application.css.scss',
          /= require foundation/,
          /@import "foundation_and_overrides";/

        assert_file 'MyApp/app/assets/javascripts/application.js',
          /\$\(document\).foundation\(\);/

        assert_file 'MyApp/app/views/layouts/application.html.erb',
          /javascript_include_tag "vendor\/modernizr"/,
          /<meta name="viewport" content="width=device-width, initial-scale=1.0" \/>/
      end

      focus
      test "installs kaminari" do
        run_generator

        assert_gem "kaminari"
        assert_file 'MyApp/app/views/kaminari/_paginator.html.erb', /pagination-centered/
      end
    end
  end
end
