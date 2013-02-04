require 'spec_helper'

feature 'User authentication' do
  scenario 'A user can see the sign up form' do
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
end
