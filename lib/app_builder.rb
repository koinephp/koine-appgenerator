module Koine
  class AppBuilder < Rails::AppBuilder

    def set_up_test_environment
      say "installing rspec"
        gem_group(:test) do
          gem 'rspec-rails', '~> 3.1.0'
          gem 'coveralls', require: false
          gem 'simplecov', require: false
          gem 'capybara'
          # gem 'capybara-webkit', '>= 1.0.0'
          gem 'database_cleaner'
          # gem 'launchy'
          gem 'shoulda-matchers', require: false
          gem 'simplecov', require: false
          gem 'timecop'
          gem 'webmock'
          gem 'machinist'
          gem 'spring-commands-rspec'
        end
      template_dir('spec')
      template '.rspec'

      configure_rspec
    end

    def require_test_gems
      inject_into_file 'spec/rails_helper.rb', after: "require 'rspec/rails'" do <<-RUBY

require 'capybara/rspec'
require 'webmock/rspec'
require 'shoulda/matchers'
RUBY
      end
    end

    def configure_rspec
      configure_coverage
      require_test_gems

      inject_into_file 'spec/rails_helper.rb', after: /^end$/ do <<-RUBY


Dir[Rails.root.join('spec/support/**/*.rb')].each do |file|
  begin
    require file
  rescue NameError => e
    puts "Could not load file \#{file}: \#{e.message}"
  end
end

RSpec.configure do |config|
  # config.include Records
  # config.include Devise::TestHelpers, type: :controller
  # config.include Formulaic::Dsl, type: :feature
  # config.include CapybaraHelper, type: :feature
end

Capybara.configure do |config|
  config.always_include_port = true
  config.app_host = 'http://example.com'
end

# Capybara.javascript_driver = :webkit
WebMock.disable_net_connect!(allow_localhost: true)

RUBY
      end
    end

    def configure_generators
      config = <<-RUBY
    config.generators do |generate|
      generate.decorator false
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs true
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
      generate.fixture_replacement :machinist
    end

      RUBY

      inject_into_class 'config/application.rb', 'Application', config
    end

    def configure_coverage
      first_line = 'ENV["RAILS_ENV"]'
      inject_into_file 'spec/rails_helper.rb', before: first_line do <<-RUBY

require 'simplecov'
SimpleCov.start 'rails'

RUBY
      end

      run "echo coveralls >> .gitignore"
    end

    def travis
      template '.travis.yml.erb', '.travis.yml'
    end

    def coveralls
      template '.coveralls.yml'
    end

    def readme
      template 'README.md.erb', 'README.md'
    end

    def disable_turbolinks
      replace_in_file 'app/assets/javascripts/application.js',
        /\/\/= require turbolinks\n/,
        ''
      replace_in_file 'Gemfile', /^.*turbolinks.*$/, ''
    end

    def set_home_page
      template_dir "app/views/pages"
      template "app/controllers/pages_controller.rb"

      unless options[:skip_rspec]
        template "spec/controllers/pages_controller_spec.rb"
      end

      route 'root to: "pages#show", id: "home"'
    end

    def remove_comments_from_routes_file
      replace_in_file 'config/routes.rb',
        /.draw do.*end/m,
        ".draw do\nend"
    end

    def set_up_smtp
      template 'config/initializers/smtp_initializer.rb'
      template 'config/smtp.yml.erb', 'config/smtp.yml'
      template 'config/smtp.yml.erb', 'config/smtp.yml.dist'
      git_ignore 'config/smtp.yml'
    end

    def configure_action_mailer
      action_mailer_host 'development', "#{app_name}.local"
      action_mailer_host 'test', 'www.example.com'
      action_mailer_host 'staging', "staging.#{app_name}.com"
      action_mailer_host 'production', "#{app_name}.com"
    end

    def setup_staging_environment
      template 'config/environments/staging.rb.erb',
        'config/environments/staging.rb'
    end
  end
end
