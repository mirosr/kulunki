require 'spec_helper'

feature 'Main menu' do
  include AuthHelper

  scenario 'Showing the main menu' do
    visit_protected root_path

    expect(current_path).to eq(root_path)

    within 'nav.main' do
      expect(page).to have_css "a.dashboard[href='#{dashboard_path}']"
      expect(page).to have_css "a.expenditures[href='#{root_path}']"
      expect(page).to have_css "a.groups[href='#{root_path}']"
      expect(page).to have_css "a.reports[href='#{root_path}']"
    end
  end
end
