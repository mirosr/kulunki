require 'spec_helper'

feature 'Dashboard' do
  scenario 'Showing the dashboard' do
    visit dashboard_path

    expect(page).to have_content 'Dashboard'
  end
end

