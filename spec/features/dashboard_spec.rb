require 'spec_helper'

feature 'Dashboard' do
  include AuthHelper

  it_behaves_like 'a protected page', :dashboard_path

  scenario 'Showing the dashboard' do
    visit_protected dashboard_path

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_text 'Dashboard'
  end
end
