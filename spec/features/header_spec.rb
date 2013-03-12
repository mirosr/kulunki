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

  scenario 'Showing the profile navigation' do
    visit_protected_as root_path, username: 'john'

    expect(current_path).to eq(root_path)

    expect(page).to have_link 'john', href: profile_path
    within 'nav.profile' do
      expect(page).to have_link('Notifications', href: root_path)
      expect(page).to have_link('Admin Panel', href: root_path)
      expect(page).to have_link('Sign Out', href: signout_path)
    end
  end
end
