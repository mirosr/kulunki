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

    expect(current_path).to eq(profile_path)

    click_link 'Edit'

    expect(current_path).to eq(edit_profile_path)

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

    expect(current_path).to eq(profile_path)

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

    expect(current_path).to eq(profile_path)

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

    expect(current_path).to eq(profile_path)
    expect(page).to have_text "Co-members: #{co_members.join(', ')}"
  end
end
