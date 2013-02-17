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

  context 'When form params are valid' do
    scenario 'An user signs up to the system' do
      visit_signup_path

      fill_in 'Username', with: 'john'
      fill_in 'Email', with: 'john@example.com'
      fill_in 'Password', with: 'john123'
      fill_in 'Confirm Password', with: 'john123'

      expect{ click_button 'Sign Up' }.to change{ User.count }.by 1
      expect(page).to have_text 'Welcome to Kulunki, john'
    end
  end

  context 'When form params are not valid' do
    scenario 'An user sees an alert messege' do
      visit_signup_path

      expect{ click_button 'Sign Up' }.not_to change{ User.count }
      expect(page).not_to have_text 'Welcome to Kulunki'
      expect(page).to have_text 'The following errors prevent your user of being saved:'
    end
  end
end

feature 'User sign in' do
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

  context 'When user credentials are valid' do
    background do
      create(:user, username: 'john', password: 'john123',
        email: 'john@example.com')

      visit signin_path
    end

    scenario 'An user signs in with username and password' do
      fill_in 'Username or Email', with: 'john'
      fill_in 'Password', with: 'john123'
      click_button 'Sign In'

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_text 'Signed in successfully'
    end

    scenario 'An user signs in with email and password' do
      fill_in 'Username or Email', with: 'john@example.com'
      fill_in 'Password', with: 'john123'
      click_button 'Sign In'

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_text 'Signed in successfully'
    end
  end

  context 'When user credentials are not valid' do
    scenario 'An user sees an alert message' do
      visit signin_path

      click_button 'Sign In'

      expect(page).not_to have_text 'Signed in successfully'
      expect(page).to have_text 'Username or email or password was incorrect'
    end
  end
end
