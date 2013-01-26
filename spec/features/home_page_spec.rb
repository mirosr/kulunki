require 'spec_helper'

feature 'Home page' do
  scenario 'Showing the dashboard' do
    visit root_path

    expect(page).to have_content 'Dashboard'
  end
end
