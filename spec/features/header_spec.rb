require 'spec_helper'

feature 'Page Header' do
  include AuthHelper

  scenario 'Showing the username' do
    visit_protected_as root_path, username: 'john'

    expect(page).to have_text 'john'
  end
end
