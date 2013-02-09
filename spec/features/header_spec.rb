require 'spec_helper'

feature 'Page Header' do
  include AuthHelper

  scenario 'Showing the username' do
    visit_protected_as root_path, username: 'john'

    expect(page).to have_text 'john'
  end

  scenario 'Showing the signout link' do
    visit_protected root_path

    expect(page).to have_link('Sign Out', href: signout_path)
  end
end
