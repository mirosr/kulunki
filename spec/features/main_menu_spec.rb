require 'spec_helper'

feature 'Main menu' do
  scenario 'Showing the main menu' do
    visit root_path

    within 'nav.main' do
      expect(page).to have_link('Dashboard', href: dashboard_path)
      expect(page).to have_text 'Expenditures'
      expect(page).to have_text 'Groups'
      expect(page).to have_text 'Reports'
      expect(page).to have_text 'Admin Panel'
    end
  end
end
