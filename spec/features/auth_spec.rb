require 'spec_helper'

feature 'User signup' do
  scenario 'A user sees the sign up form' do
    visit signup_path

    within 'header.page' do
      expect(page).to have_text 'Kulunki'
      expect(page).to have_text 'Please sign up to continue'
    end
    within 'form#new_user' do
      expect(page).to have_field 'Username'
      expect(page).to have_field 'Email'
      expect(page).to have_field 'Password'
      expect(page).to have_field 'Confirm Password'
      expect(page).to have_button 'Sign Up'
    end
  end

  scenario 'An user signs up to the system' do
    visit signup_path

    fill_in 'Username', with: 'john'
    fill_in 'Email', with: 'john@example.com'
    fill_in 'Password', with: 'john123'
    fill_in 'Confirm Password', with: 'john123'

    expect{ click_button 'Sign Up' }.to change{ User.count }.by 1
    expect(page).to have_text 'Welcome to Kulunki, john.'
  end

  scenario 'An user sees an alert when params are not valid' do
    visit signup_path

    expect{ click_button 'Sign Up' }.not_to change{ User.count }
    expect(page).not_to have_text 'Welcome to Kulunki'
    expect(page).to have_text 'The following errors prevent your user of being saved:'
  end
end
