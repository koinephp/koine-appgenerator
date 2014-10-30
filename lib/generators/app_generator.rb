require 'rails/generators/rails/app/app_generator'

module Koine
  module Generators
    class AppGenerator < Rails::Generators::AppGenerator
      source_paths << Rails::Generators::AppGenerator.source_root
    end
  end
end

