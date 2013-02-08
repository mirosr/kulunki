require 'spec_helper'

feature 'Home page' do
  include AuthHelper

  it_behaves_like 'a protected page', :root_path

  scenario 'Showing the dashboard' do
    visit_protected root_path

    expect(current_path).to eq(root_path)
    expect(page).to have_text 'Dashboard'
  end
end
