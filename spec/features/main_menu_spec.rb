require 'spec_helper'

feature 'Main menu' do
  scenario 'Showing the main menu' do
    create(:user, username: 'john', password: 'john123',
      email: 'john@example.com')

    visit root_path

    fill_in 'Username or Email', with: 'john'
    fill_in 'Password', with: 'john123'
    click_button 'Sign In'

    within 'nav.main' do
      expect(page).to have_link('Dashboard', href: dashboard_path)
      expect(page).to have_text 'Expenditures'
      expect(page).to have_text 'Groups'
      expect(page).to have_text 'Reports'
      expect(page).to have_text 'Admin Panel'
    end
  end
end
