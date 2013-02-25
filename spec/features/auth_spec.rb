require 'spec_helper'

feature 'User sign up' do
  def visit_signup_path
    visit signin_path
    click_link 'Sign Up'
  end

  scenario 'An user sees the sign up form' do
    visit_signup_path

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

  scenario 'An user signs up to the system successfully' do
    create(:user, :admin)

    visit_signup_path

    fill_in 'Username', with: 'john'
    fill_in 'Email', with: 'john@example.com'
    fill_in 'Password', with: 'john123'
    fill_in 'Confirm Password', with: 'john123'

    expect{ click_button 'Sign Up' }.to change{ User.count }.by 1
    expect(User.find_by_username('john')).not_to be_admin
    expect(page).to have_text 'Welcome to Kulunki, john'
  end

  scenario 'Show an alert messege when form params are invalid' do
    visit_signup_path

    expect{ click_button 'Sign Up' }.not_to change{ User.count }
    expect(page).not_to have_text 'Welcome to Kulunki'
    expect(page).to have_text 'The following errors prevent your user of being saved:'
  end

  scenario 'The fist created user is granted with an admin role' do
    visit_signup_path

    fill_in 'Username', with: 'john'
    fill_in 'Email', with: 'john@example.com'
    fill_in 'Password', with: 'john123'
    fill_in 'Confirm Password', with: 'john123'
    click_button 'Sign Up'

    expect(User.find_by_username('john')).to be_admin
    expect(page).to have_text 'You are the first user, so an admin role was granted to you'
  end
end

feature 'User sign in' do
  def fill_in_signin_form(username, password)
    fill_in 'Username or Email', with: username
    fill_in 'Password', with: password
    click_button 'Sign In'
  end

  scenario 'An user sees the sign in form' do
    visit signin_path

    within 'header.page' do
      expect(page).to have_text 'Kulunki'
      expect(page).to have_text 'Please sign in to continue'
    end
    within 'form#new_session' do
      expect(page).to have_field 'Username or Email'
      expect(page).to have_field 'Password'
      expect(page).to have_field 'Remember Me'
      expect(page).to have_link 'Forgot password?', href: reset_password_path
      expect(page).to have_link 'Sign Up', href: signup_path
      expect(page).to have_button 'Sign In'
    end
  end

  scenario 'An user signs in successfully with username and password' do
    create(:user, username: 'john', password: 'john123')

    visit signin_path

    fill_in_signin_form('john', 'john123')

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_text 'Signed in successfully'
  end

  scenario 'An user signs in successfully with email and password' do
    create(:user, email: 'john@example.com', password: 'john123')

    visit signin_path

    fill_in_signin_form('john@example.com', 'john123')

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_text 'Signed in successfully'
  end

  scenario 'Show an alert message when entered credentials are invalid' do
    visit signin_path

    click_button 'Sign In'

    expect(page).not_to have_text 'Signed in successfully'
    expect(page).to have_text 'Username or email or password was incorrect'
  end
end
