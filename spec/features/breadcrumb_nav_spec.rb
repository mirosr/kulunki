require 'spec_helper'

feature 'Breadcrumb Navigation' do
  scenario 'Showing the breadcrumb navigation' do
    visit root_path

    within 'header.page .breadcrumb_nav' do
      expect(page).to have_content 'Kulunki'
      expect(page).to have_content 'Household Name'
      expect(page).to have_content 'Current Period'
    end
  end
end
