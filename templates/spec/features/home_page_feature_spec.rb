require 'rails_helper'

feature "Home Page" do
  scenario "visiting home page" do
    visit "/"
    expect(page.status_code).to be(200)
  end
end
