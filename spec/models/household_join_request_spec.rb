require 'spec_helper'

describe HouseholdJoinRequest do
  it 'has a valid factory' do
    expect(build(:household_join_request)).to be_valid
  end

  describe 'mass assignment' do
    it { should allow_mass_assignment_of(:user) }
    it { should allow_mass_assignment_of(:household) }
  end

  describe 'validations' do
    it 'should be unique' do
      u = create(:user, username: 'john')
      h = create(:household, name: 'my household')
      create(:household_join_request, user: u, household: h)

      expect(build(:household_join_request,
        user: u, household: h)).not_to be_valid

      expect(build(:household_join_request,
        user: build(:user), household: h)).to be_valid
      expect(build(:household_join_request,
        user: u, household: build(:household))).to be_valid

      expect(build(:household_join_request)).to be_valid
    end

    it { should ensure_inclusion_of(:status).in_array(%w[pending]) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:household) }
  end
end
