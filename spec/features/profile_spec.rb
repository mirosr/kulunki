require 'spec_helper'

feature 'User Profile' do
  include AuthHelper

  it_behaves_like 'a protected page', :profile_path

  scenario 'Show the user profile' do
    user = build(:user, username: 'john', email: 'john@example.com',
      full_name: 'John Doe')

    visit_protected_as_user profile_path, user

    expect(current_path).to eq(profile_path)
    expect(page).to have_text 'Your Profile'
    expect(page).to have_text 'Email: john@example.com'
    expect(page).to have_text 'Username: john'
    expect(page).to have_text 'Name: John Doe'
    expect(page).to have_text 'Household: none'
    expect(page).to have_text 'Co-members: none'
  end
end

