require 'spec_helper'

feature 'Password Reset' do
  scenario 'An user sees the password reset form' do
    visit reset_password_path

    within 'header.page' do
      expect(page).to have_text 'Kulunki'
      expect(page).to have_text 'Please enter email to reset your password'
    end
    within 'form#reset_password' do
      expect(page).to have_field 'Email'
      expect(page).to have_button 'Reset Password'
    end
  end

  context 'When the given email is valid and existing' do
    scenario 'A password reset email is sent to the user' do
      create(:user, email: 'john@example.com')

      visit reset_password_path

      fill_in 'Email', with: 'john@example.com'
      click_button 'Reset Password'

      expect(page).to have_text 'An email with instructions was sent to you'
    end
  end

  context 'When the given email is not valid' do
    scenario 'Showing an alert message' do
      visit reset_password_path

      fill_in 'Email', with: 'invalid'
      click_button 'Reset Password'

      expect(page).to have_text 'The email address you provided was invalid. Please try again.'
    end
  end
  
  context 'When the given email is not existing' do
    scenario 'Showing a fake email sent message' do
      create(:user, email: 'john@example.com')

      visit reset_password_path

      fill_in 'Email', with: 'john@example.com'
      click_button 'Reset Password'

      expect(page).to have_text 'An email with instructions was sent to you'
    end
  end
end

feature 'Password Change' do
  scenario 'An user sees the password change form' do
    visit change_password_path('token_value')

    within 'header.page' do
      expect(page).to have_text 'Kulunki'
      expect(page).to have_text 'Please enter a new password'
    end
    within 'form#change_password' do
      expect(page).to have_field 'New Password'
      expect(page).to have_field 'Confirm New Password'
      expect(page).to have_button 'Change Password'
    end
  end
end
