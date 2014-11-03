require 'rails_helper'

feature "Home Page" do
  scenario "visiting home page" do
    visit root_path
    expect(page.html).to have_text("Hello World!")
  end
end
