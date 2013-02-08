require 'spec_helper'

feature 'Home page' do
  context 'when user is not signed in' do
    scenario 'Redirecting user to sign in' do
      visit root_path

      expect(current_path).to eq(signin_path)
      expect(page).to have_css('form#new_session')
    end
  end

  scenario 'Showing the dashboard' do
    create(:user, username: 'john', password: 'john123',
      email: 'john@example.com')

    visit root_path

    fill_in 'Username or Email', with: 'john'
    fill_in 'Password', with: 'john123'
    click_button 'Sign In'

    expect(page).to have_text 'Dashboard'
  end
end
