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

      def install_rspec
        build :install_rspec unless options[:skip_rspec]
      end

      def configure_generators
        build :configure_generators
      end

      def get_builder_class
        AppBuilder
      end

      def copy_files
        build :readme
        # build :coveralls
        build :travis
      end

      def disable_turbolinks
        build(:disable_turbolinks)
      end
    end
  end
end

templates_path = File.expand_path('../../../templates', __FILE__)

Koine::Generators::AppGenerator.source_paths << Rails::Generators::AppGenerator.source_root
Koine::Generators::AppGenerator.source_paths << templates_path
Koine::Generators::AppGenerator.templates_path = templates_path

