require 'spec_helper'

describe Household do
  it 'has a valid factory' do
    expect(build(:household)).to be_valid
  end

  describe 'mass assignment' do
    it { should allow_mass_assignment_of(:name) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
