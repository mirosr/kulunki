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
end
