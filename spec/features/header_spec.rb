require 'spec_helper'

feature 'Page Header' do
  include AuthHelper

  scenario 'Showing the breadcrumb navigation' do
    visit_protected root_path

    expect(current_path).to eq(root_path)

    within 'header.page .breadcrumb_nav' do
      expect(page).to have_text 'Kulunki'
      expect(page).to have_text 'Household Name'
      expect(page).to have_text 'Current Period'
    end
  end

  scenario 'Show the link to user profile' do
    visit_protected_as root_path, username: 'john'

    expect(current_path).to eq(root_path)
    expect(page).to have_link 'john', href: profile_path
  end

  scenario 'Show the signout link' do
    visit_protected root_path

    expect(current_path).to eq(root_path)
    expect(page).to have_link('Sign Out', href: signout_path)
  end
end
