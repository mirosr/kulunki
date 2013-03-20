require 'spec_helper'

feature 'Households' do
  include AuthHelper

  it_behaves_like 'a protected page', :new_household_path

  scenario 'An user sees the create household form' do
    visit_protected profile_path

    expect(current_path).to eq(profile_path)

    click_link 'Create New Household'

    expect(current_path).to eq(new_household_path)

    within 'header.content' do
      expect(page).to have_text 'Create New Household'
    end
    within 'form#new_household' do
      expect(page).to have_field 'Name'
      expect(page).to have_button 'Save'
    end
  end

  scenario 'The user creates a household if he is still not a member of any' do
    visit_protected profile_path

    expect(current_path).to eq(profile_path)

    click_link 'Create New Household'

    expect(current_path).to eq(new_household_path)

    within 'form#new_household' do
      fill_in 'Name', with: 'My household'
    end

    expect{ click_button 'Save' }.to change{ Household.count }
    expect(current_path).to eq(profile_path)
    expect(page).to have_text('Your household was created successfully')
    expect(page).to have_text('My household')
    expect(page).not_to have_text 'Create New Household'
  end

  scenario 'Show an alert message after failed create' do
    visit_protected profile_path

    expect(current_path).to eq(profile_path)

    click_link 'Create New Household'

    expect(current_path).to eq(new_household_path)

    expect{ click_button 'Save' }.not_to change{ Household.count }
    expect(current_path).to eq(households_path)
    expect(page).to have_text 'The following errors prevent your household of being saved:'
  end

  scenario "The user can't request joining when no housholds exist" do
    visit_protected profile_path

    expect(current_path).to eq(profile_path)
    expect(page).not_to have_css '#households'
    expect(page).not_to have_link 'Request joining'
    expect(page).to have_text 'Create New Household'
  end

  scenario 'An user sees the join household form' do
    create(:household, name: 'My household')

    visit_protected profile_path

    expect(current_path).to eq(profile_path)
    expect(page).to have_text 'Create New Household'

    within 'form#join_household' do
      expect(page).to have_select 'household', with_options: ['My household']
      expect(page).to have_button 'Request joining'
    end
  end

  scenario 'The user requests joining to an existing household' do
    create(:household, name: 'My household')

    visit_protected profile_path

    expect(current_path).to eq(profile_path)

    select 'My household', from: 'household'
    click_button 'Request joining'

    expect(current_path).to eq(profile_path)
    expect(page).to have_text('Your request for joining My household was sent for approval')
    expect(page).to have_text('Pending request for My household')
    expect(page).not_to have_text 'Create New Household'
    expect(page).not_to have_css 'form#join_household'
  end
end
