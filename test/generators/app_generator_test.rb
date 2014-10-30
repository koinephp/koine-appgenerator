require_relative '../test_helper'

module Koine
  module Generators
    class AppGeneratorTest < Rails::Generators::TestCase
      destination APP_FOLDER
      tests AppGenerator
      setup :prepare_destination
      arguments ['root']

      test "generates assets" do
        run_generator

        assert_file("root/app/views/layouts/application.html.erb", /stylesheet_link_tag\s+'application', media: 'all', 'data-turbolinks-track' => true/)
        assert_file("root/app/views/layouts/application.html.erb", /javascript_include_tag\s+'application', 'data-turbolinks-track' => true/)
        assert_file("root/app/assets/stylesheets/application.css")
        assert_file("root/app/assets/javascripts/application.js")
      end
    end
  end
end
