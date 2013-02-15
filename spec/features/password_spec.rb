require 'spec_helper'

feature 'Password Reset' do
  include EmailHelper

  background do
    clear_email_queue
  end

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
    scenario 'Sending reset password instructions to the user' do
      user = create(:user, email: 'john@example.com')

      visit reset_password_path

      fill_in 'Email', with: 'john@example.com'
      click_button 'Reset Password'

      user.reload

      expect(last_email).not_to be_nil
      expect(last_email.to).to eq(['john@example.com'])
      expect(last_email.body).to include(
        change_password_url(user.reset_password_token))
      expect(page).to have_text 'An email with instructions was sent to you'
    end
  end

  context 'When the given email is not valid' do
    scenario 'Showing an alert message' do
      visit reset_password_path

      fill_in 'Email', with: 'invalid'
      click_button 'Reset Password'

      expect(page).to have_text 'The email address you provided was invalid. Please try again.'
      expect(last_email).to be_nil
    end
  end
  
  context 'When the given email is not existing' do
    scenario 'Showing a fake email sent message' do
      create(:user, email: 'john@example.com')

      visit reset_password_path

      fill_in 'Email', with: 'nonexisting@example.com'
      click_button 'Reset Password'

      expect(page).to have_text 'An email with instructions was sent to you'
      expect(last_email).to be_nil
    end
  end
end

feature 'Password Change' do
  context 'When the given token is valid' do
    scenario 'An user sees the password change form' do
      user = create(:user_with_reset_password_token)

      visit change_password_path(user.reset_password_token)

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

  context 'When the given token is not valid' do
    scenario 'Showing the sign in form' do
      visit change_password_path('invalid_token')

      expect(current_path).to eq(signin_path)
    end
  end

  context 'When the given token has expired' do
    scenario 'Showing reset password form with an alert message' do
      user = create(:user_with_expired_reset_password_token)

      visit change_password_path(user.reset_password_token)

      expect(current_path).to eq(reset_password_path)
      expect(page).to have_text 'Sorry, this reset password token has expited. Please request a new one.'
    end
  end
end
