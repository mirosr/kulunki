require 'spec_helper'

feature 'Breadcrumb Navigation' do
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
end
