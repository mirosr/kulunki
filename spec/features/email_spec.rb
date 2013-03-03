require 'spec_helper'

feature 'Email Change' do
  include AuthHelper
  include EmailHelper

  background do
    clear_email_queue
  end

  def fill_in_change_email_form(email, password)
    within('form#change_email') do
      fill_in 'New Email', with: email
      fill_in 'Password', with: password
      click_button 'Change Email'
    end
  end

  scenario 'An user sees the change email form' do
    visit_protected_as profile_path, email: 'john@example.com'

    expect(current_path).to eq(profile_path)

    click_link 'Edit'

    expect(current_path).to eq(edit_profile_path)

    within 'header.content' do
      expect(page).to have_text 'Edit Your Profile'
    end
    within 'form#change_email' do
      expect(page).to have_text 'Current Email: john@example.com'
      expect(page).to have_field 'New Email'
      expect(page).to have_field 'Password'
      expect(page).to have_button 'Change Email'
    end
    expect(page).to have_link 'Back to Profile', href: profile_path
  end

  scenario 'An user changes his email successfully' do
    user = create(:user, password: 'john123')

    visit_protected_as_user profile_path, user, 'john123'

    expect(current_path).to eq(profile_path)

    click_link 'Edit'

    expect(current_path).to eq(edit_profile_path)

    fill_in_change_email_form('john.doe@example.com', 'john123')

    user.reload

    expect(last_email).not_to be_nil
    expect(last_email.to).to eq(['john.doe@example.com'])
    expect(last_email.body).to include(
      change_email_url(user.change_email_token))

    expect(current_path).to eq(profile_path)
    expect(page).to have_text 'An email with instructions was sent to you'
    expect(page).not_to have_text 'Email: john.doe@example.com'

    visit change_email_path(user.change_email_token)

    expect(current_path).to eq(signin_path)
    expect(page).to have_text 'Your email has been changed to john.doe@example.com'
  end

  scenario 'Show an alert message when new email is invalid' do
    visit_protected_as profile_path, password: 'john123'

    expect(current_path).to eq(profile_path)

    click_link 'Edit'

    expect(current_path).to eq(edit_profile_path)

    fill_in_change_email_form('john_wrong_email', 'john123')

    expect(last_email).to be_nil

    expect(current_path).to eq(profile_change_email_path)
    expect(page).to have_text 'The new email was incorrect'
    expect(page).not_to have_text 'Email: john_wrong_email'
  end

  scenario 'Show an alert message when new email is already taken' do
    create(:user, email: 'john.doe@example.com')

    visit_protected_as profile_path, password: 'john123'

    expect(current_path).to eq(profile_path)

    click_link 'Edit'

    expect(current_path).to eq(edit_profile_path)

    fill_in_change_email_form('john.doe@example.com', 'john123')

    expect(last_email).to be_nil

    expect(current_path).to eq(profile_change_email_path)
    expect(page).to have_text 'The new email is already taken'
    expect(page).not_to have_text 'Email: john.doe@example.com'
  end

  scenario 'Show an alert message when password is invalid' do
    visit_protected_as profile_path, email: 'john@example.com',
      password: 'john123'

    expect(current_path).to eq(profile_path)

    click_link 'Edit'

    expect(current_path).to eq(edit_profile_path)

    fill_in_change_email_form('john@example.com', 'wrong password')

    expect(last_email).to be_nil

    expect(current_path).to eq(profile_change_email_path)
    expect(page).to have_text 'Given password was incorrect'
  end

  scenario 'Show the sign in form when entered token is invalid' do
    visit change_email_path('invalid_token')

    expect(current_path).to eq(signin_path)
  end

  scenario 'Show an alert message when entered token has expired' do
    user = create(:user_with_expired_change_email_token)

    visit change_email_path(user.change_email_token)

    expect(current_path).to eq(signin_path)
    expect(page).to have_text 'Sorry, this change email token has expited. Please request a new one.'
  end
end

