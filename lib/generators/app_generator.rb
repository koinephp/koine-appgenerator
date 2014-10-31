require 'rails/generators/rails/app/app_generator'
require 'app_builder'

module Koine
  module Generators
    class AppGenerator < Rails::Generators::AppGenerator
      class_option :database,
        type: :string,
        aliases: '-d',
        default: 'mysql',
        desc: "Preconfigure for selected database (options: #{DATABASES.join('/')})"

      class_option :skip_test_unit,
        type: :boolean,
        aliases: '-T',
        default: true,
        desc: 'Skip Test::Unit files'

      class_option :skip_rspec,
        type: :boolean,
        default: false,
        desc: 'Skip rspec installation'

      def install_rspec
        return if options[:skip_rspec]

        build :install_rspec

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
      end

      def configure_generators
        build :configure_generators
      end

      def get_builder_class
        AppBuilder
      end
    end
  end
end

templates_path = File.expand_path('../../../templates', __FILE__)
Koine::Generators::AppGenerator.source_paths << Rails::Generators::AppGenerator.source_root
Koine::Generators::AppGenerator.source_paths << templates_path

