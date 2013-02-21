require 'spec_helper'

describe Household do
  it 'has a valid factory' do
    expect(build(:household)).to be_valid
  end

  describe 'mass assignment' do
    it { should allow_mass_assignment_of(:name) }
  end

  describe 'validations' do
    context 'name' do
      it { should validate_presence_of(:name) }

      it 'should be unique' do
        create(:household, name: 'my household')
        expect(build(:household, name: 'my household')).not_to be_valid
      end
    end

    it { should validate_presence_of(:head) }
  end

  describe 'associations' do
    it { should belong_to(:head) }
    it { should have_many(:members) }
  end
end
