require 'spec_helper'

feature 'Password' do
  scenario 'An user sees the password reset form' do
    visit password_reset_path

    within 'header.page' do
      expect(page).to have_text 'Kulunki'
      expect(page).to have_text 'Please enter email to reset your password'
    end
    within 'form#password_reset' do
      expect(page).to have_field 'Email'
      expect(page).to have_button 'Reset Password'
    end
  end

  context 'When the given email is valid and existing' do
    scenario 'An user resets his password' do
      create(:user, email: 'john@example.com')

      visit password_reset_path

      fill_in 'Email', with: 'john@example.com'
      click_button 'Reset Password'

      expect(page).to have_text 'An email with instructions was sent to you'
    end
  end

  context 'When the given email is not valid' do
    scenario 'Showing an alert message' do
      visit password_reset_path

      fill_in 'Email', with: 'invalid'
      click_button 'Reset Password'

      expect(page).to have_text 'The email address you provided was invalid. Please try again.'
    end
  end
  
  context 'When the given email is not existing' do
    scenario 'Showing a fake email sent message' do
      create(:user, email: 'john@example.com')

      visit password_reset_path

      fill_in 'Email', with: 'john@example.com'
      click_button 'Reset Password'

      expect(page).to have_text 'An email with instructions was sent to you'
    end
  end
end
