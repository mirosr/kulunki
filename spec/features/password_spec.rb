require 'spec_helper'

feature 'Password Reset' do
  include AuthHelper
  include EmailHelper

  background do
    clear_email_queue
  end

  def visit_reset_password_path
    visit signin_path
    click_link 'Forgotten your password?'
  end

  def fill_in_reset_password_form(email)
    within 'form#reset_password' do
      fill_in 'Email', with: email
      click_button 'Reset Password'
    end
  end

  def fill_in_change_password_form(password, confirm_password)
    within 'form#change_password' do
      fill_in 'New Password', with: password
      fill_in 'Confirm New Password', with: confirm_password
      click_button 'Change Password'
    end
  end

  scenario 'An user sees the password reset form' do
    visit_reset_password_path

    expect(current_path).to eq(reset_password_path)

    within 'section.auth' do
      expect(page).to have_text 'Please enter email to reset your password'
    end
    within 'form#reset_password' do
      expect(page).to have_field 'Email'
      expect(page).to have_button 'Reset Password'
    end
  end

  scenario 'An user sees the change password form' do
    user = create(:user_with_reset_password_token)

    visit change_password_path(user.reset_password_token)

    expect(current_path).to eq(change_password_path(user.reset_password_token))

    within 'section.auth' do
      expect(page).to have_text 'Please enter a new password'
    end
    within 'form#change_password' do
      expect(page).to have_field 'New Password'
      expect(page).to have_field 'Confirm New Password'
      expect(page).to have_button 'Change Password'
    end
  end

  scenario 'An user resets his password successfully' do
    user = create(:user, email: 'john@example.com')

    visit_reset_password_path

    expect(current_path).to eq(reset_password_path)

    fill_in_reset_password_form('john@example.com')

    user.reload

    expect(last_email).not_to be_nil
    expect(last_email.to).to eq(['john@example.com'])
    expect(last_email.body).to include(
      change_password_url(user.reset_password_token))

    expect(current_path).to eq(reset_password_path)
    expect(page).to have_text 'An email with instructions was sent to you'

    visit change_password_path(user.reset_password_token)

    expect(current_path).to eq(change_password_path(user.reset_password_token))

    fill_in_change_password_form('secure_password', 'secure_password')

    expect(current_path).to eq(signin_path)
    expect(page).to have_text 'Your password has been changed'

    fill_in_signin_form(user.username, 'secure_password')

    expect(current_path).to eq(root_path)
  end

  scenario 'Show an alert message when entered email is invalid' do
    visit_reset_password_path

    expect(current_path).to eq(reset_password_path)

    fill_in_reset_password_form('invalid')

    expect(current_path).to eq(reset_password_path)
    expect(page).to have_text 'The email address you provided was invalid. Please try again.'
    expect(last_email).to be_nil
  end
  
  scenario 'Show a fake email sent message when entered email does not exist' do
    create(:user, email: 'john@example.com')

    visit_reset_password_path

    expect(current_path).to eq(reset_password_path)

    fill_in_reset_password_form('nonexisting@example.com')

    expect(current_path).to eq(reset_password_path)
    expect(page).to have_text 'An email with instructions was sent to you'
    expect(last_email).to be_nil
  end

  scenario 'Show the sign in form when entered token is invalid' do
    visit change_password_path('invalid_token')

    expect(current_path).to eq(signin_path)
  end

  scenario 'Show an alert message when entered token has expired' do
    user = create(:user_with_expired_reset_password_token)

    visit change_password_path(user.reset_password_token)

    expect(current_path).to eq(reset_password_path)
    expect(page).to have_text 'Sorry, this reset password token has expited. Please request a new one.'
  end

  scenario 'Show an alert message when entered passwords do not match' do
    user = create(:user_with_reset_password_token)

    visit change_password_path(user.reset_password_token)

    expect(current_path).to eq(change_password_path(user.reset_password_token))

    fill_in_change_password_form('secure_password', 'password123')

    expect(current_path).to eq(change_password_path(user.reset_password_token))
    expect(page).to have_text "Password doesn't match confirmation"
  end
end

feature 'Password Change' do
  include AuthHelper

  def fill_in_change_password_form(current_password,
    password, password_confirmation)
    within 'form#change_password' do
      fill_in 'Current Password', with: current_password
      fill_in 'password', with: password
      fill_in 'password_confirmation', with: password_confirmation
      click_button 'Change Password'
    end
  end
  
  scenario 'An user sees the change password form' do
    visit_protected profile_path

    expect(current_path).to eq(profile_path)

    click_link 'Edit'

    expect(current_path).to eq(edit_profile_path)

    within 'header.content' do
      expect(page).to have_text 'Edit Your Profile'
    end
    within 'form#change_password' do
      expect(page).to have_field 'Current Password'
      expect(page).to have_field 'New Password'
      expect(page).to have_field 'Confirm New Password'
      expect(page).to have_button 'Change Password'
    end
    expect(page).to have_link 'Back to Profile', href: profile_path
  end

  scenario 'An user changes his password successfully' do
    visit_protected_as profile_path, username: 'john', password: 'john123'

    expect(current_path).to eq(profile_path)

    click_link 'Edit'

    expect(current_path).to eq(edit_profile_path)

    fill_in_change_password_form('john123', 'new1234', 'new1234')

    expect(current_path).to eq(profile_path)
    expect(page).to have_text 'Your password was changed successfully'

    visit signout_path

    expect(current_path).to eq(signin_path)

    fill_in_signin_form('john', 'new1234')

    expect(page).to have_text 'john'
  end

  scenario 'Show an alert message when current password is invalid' do
    visit_protected_as profile_path, username: 'john', password: 'john123'

    expect(current_path).to eq(profile_path)

    click_link 'Edit'

    expect(current_path).to eq(edit_profile_path)

    fill_in_change_password_form('wrong password', 'new1234', 'new1234')

    expect(current_path).to eq(profile_change_password_path)
    expect(page).to have_text 'Current password was incorrect'
  end

  scenario "Show an alert message when new passwords don't match" do
    visit_protected_as profile_path, username: 'john', password: 'john123'

    expect(current_path).to eq(profile_path)

    click_link 'Edit'

    expect(current_path).to eq(edit_profile_path)

    fill_in_change_password_form('john123', 'new1234', 'new6789')

    expect(current_path).to eq(profile_change_password_path)
    expect(page).to have_text "The new passwords didn't matched"
  end
end
