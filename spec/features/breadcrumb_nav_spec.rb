require 'spec_helper'

feature 'Breadcrumb Navigation' do
  scenario 'Showing the breadcrumb navigation' do
    create(:user, username: 'john', password: 'john123',
      email: 'john@example.com')

    visit root_path

    fill_in 'Username or Email', with: 'john'
    fill_in 'Password', with: 'john123'
    click_button 'Sign In'

    within 'header.page .breadcrumb_nav' do
      expect(page).to have_text 'Kulunki'
      expect(page).to have_text 'Household Name'
      expect(page).to have_text 'Current Period'
    end
  end
end
