require 'spec_helper'

feature 'User Profile' do
  include AuthHelper

  it_behaves_like 'a protected page', :profile_path

  def fill_in_edit_profile_form(username, name)
    within 'form#edit_profile' do
      fill_in 'Username', with: username
      fill_in 'Name', with: name
      click_button 'Save'
    end
  end

  scenario 'Show the user profile' do
    visit_protected_as profile_path, username: 'john',
      email: 'john@example.com', full_name: 'John Doe'

    expect(current_path).to eq(profile_path)
    expect(page).to have_text 'Your Profile'
    expect(page).to have_text 'Email: john@example.com'
    expect(page).to have_text 'Username: john'
    expect(page).to have_text 'Name: John Doe'
    expect(page).to have_text 'Household: none'
    expect(page).to have_link 'Create New Household'
    expect(page).to have_text 'Co-members: none'
    expect(page).to have_link 'Edit', href: edit_profile_path
  end

  scenario 'An user sees the edit profile form' do
    user = create(:user, username: 'john', full_name: 'John Doe')

    visit_protected_as_user profile_path, user

    click_link 'Edit'

    within 'header.content' do
      expect(page).to have_text 'Edit Your Profile'
    end
    within 'form#edit_profile' do
      expect(page).to have_field 'Username', with: user.username
      expect(page).to have_field 'Name', with: user.full_name
      expect(page).to have_button 'Save'
    end
    expect(page).to have_link 'Back to Profile', href: profile_path
  end

  scenario 'An user edits his personal data successfully' do
    visit_protected_as profile_path, username: 'john',
      full_name: 'John Doe'

    click_link 'Edit'

    expect(current_path).to eq(edit_profile_path)

    fill_in_edit_profile_form('jonathan', 'Jonathan Doe')

    expect(current_path).to eq(profile_path)
    expect(page).to have_text 'Your personal data was updated successfully'
    expect(page).to have_text 'jonathan'
    expect(page).to have_text 'Jonathan Doe'
  end

  scenario 'Show an alert message after failed update' do
    visit_protected_as profile_path, username: 'john',
      full_name: 'John Doe'

    click_link 'Edit'

    expect(current_path).to eq(edit_profile_path)

    fill_in_edit_profile_form('', 'Jonathan Doe')

    expect(current_path).to eq(edit_profile_path)
    expect(page).to have_text 'Your personal data failed to update'
    expect(page).to have_text 'john'
    expect(page).not_to have_text 'Jonathan Doe'
  end

  scenario 'An user sees other household members' do
    user = create(:user_head_of_household, username: 'john')
    co_members = %w{bob deb ed joe kim}
    co_members.each do |username|
      create(:user, username: username, household: user.household)
    end

    visit_protected_as_user profile_path, user

    expect(page).to have_text "Co-members: #{co_members.join(', ')}"
  end
end

feature 'Change email from profile' do
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

    click_link 'Edit'

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

  scenario 'An user requests an email change' do
    user = create(:user, password: 'john123')

    visit_protected_as_user profile_path, user, 'john123'

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
  end

  scenario 'Show an alert message when new email is invalid' do
    visit_protected_as profile_path, password: 'john123'

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

    click_link 'Edit'

    expect(current_path).to eq(edit_profile_path)

    fill_in_change_email_form('john@example.com', 'wrong password')

    expect(last_email).to be_nil

    expect(current_path).to eq(profile_change_email_path)
    expect(page).to have_text 'Given password was incorrect'
  end
end
