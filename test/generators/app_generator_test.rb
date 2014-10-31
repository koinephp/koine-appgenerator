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
    end
  end
end
