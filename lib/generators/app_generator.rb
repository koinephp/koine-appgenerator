require 'rails/generators/rails/app/app_generator'
require 'app_builder'
require 'generators/helper'

module Koine
  module Generators
    class AppGenerator < Rails::Generators::AppGenerator
      include Helper

      def self.templates_path=(path)
        @@templates_path = path
      end

      def self.templates_path
        @@templates_path
      end

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

      def finish_template
        invoke :koine_customizations
        super
      end

      def koine_customizations
        invoke :remove_comments_from_routes_file
        invoke :disable_turbolinks
        invoke :add_high_voltage
        invoke :set_home_page
        invoke :install_draper
        invoke :copy_files
        invoke :set_up_development_environment
        invoke :set_up_staging_environment
        invoke :set_up_test_environment
        invoke :set_up_smtp
        invoke :configure_action_mailer
        invoke :customize_error_pages
        invoke :configure_time_zone
        invoke :copy_locale_files
        invoke :install_zurb_foundation
      end

      def copy_locale_files
        build :copy_locale_files
        copy_dir 'config/locales'
      end

      def set_up_test_environment
        build :set_up_test_environment unless options[:skip_rspec]
      end

      def set_up_development_environment
        build :raise_on_delivery_errors
        build :raise_on_unpermitted_params
        build :configure_generators
      end

      def set_up_staging_environment
        build :setup_staging_environment
      end

      def remove_comments_from_routes_file
        build :remove_comments_from_routes_file
      end

      def copy_files
        build :readme
        # build :coveralls
        build :travis
      end

      def disable_turbolinks
        build(:disable_turbolinks)
      end

      def add_high_voltage
        gem 'high_voltage', '~> 2.2.1'
      end

      def set_home_page
        build :set_home_page
      end

      def set_up_smtp
        build :set_up_smtp
      end

      def configure_action_mailer
        build :configure_action_mailer
      end

      def install_draper
        gem 'draper', '~> 1.3'
      end

      def customize_error_pages
        build :customize_error_pages
      end

      def configure_time_zone
        build :configure_time_zone
      end

      def install_zurb_foundation
        say "Installing zourb foundation"
        gem 'foundation-rails'

        build :install_zurb_fundation
      end

      protected

      def get_builder_class
        AppBuilder
      end
    end
  end
end

templates_path = File.expand_path('../../../templates', __FILE__)

Koine::Generators::AppGenerator.source_paths << Rails::Generators::AppGenerator.source_root
Koine::Generators::AppGenerator.source_paths << templates_path
Koine::Generators::AppGenerator.templates_path = templates_path

