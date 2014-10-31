
module Koine
  class AppBuilder < Rails::AppBuilder

    def install_rspec
      say "installing rspec"
      template_dir('spec')
      template '.rspec'
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
  end
end
