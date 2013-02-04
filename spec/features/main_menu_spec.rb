require 'spec_helper'

feature 'Main menu' do
  scenario 'Showing the main menu' do
    visit root_path

    expect(page).to have_link('Dashboard', href: dashboard_path)
    expect(page).to have_content 'Expenditures'
    expect(page).to have_content 'Groups'
    expect(page).to have_content 'Reports'
    expect(page).to have_content 'Admin Panel'
  end
end
