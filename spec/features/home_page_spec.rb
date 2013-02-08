require 'spec_helper'

feature 'Home page' do
  include AuthHelper

  context 'When user is not signed in' do
    scenario 'Redirecting user to sign in' do
      visit root_path

      expect(current_path).to eq(signin_path)
      expect(page).to have_css('form#new_session')
    end
  end

  scenario 'Showing the dashboard' do
    visit_protected root_path

    expect(page).to have_text 'Dashboard'
  end
end
