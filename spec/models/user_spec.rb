require 'spec_helper'

describe User do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  describe 'mass assignment' do
    it { should allow_mass_assignment_of(:username) }
    it { should allow_mass_assignment_of(:email) }
    it { should allow_mass_assignment_of(:password) }
    it { should allow_mass_assignment_of(:password_confirmation) }
  end

  describe 'validations' do
    context 'username' do
      it { should validate_presence_of(:username) }

      it 'should be unique' do
        create(:user, username: 'john')
        expect(build(:user, username: 'john')).not_to be_valid
      end
    end

    context 'email' do
      it { should validate_presence_of(:email) }
      it { should allow_value('test@example.com').for(:email) }
      it { should_not allow_value('test').for(:email) }

      it 'should be unique' do
        create(:user, email: 'john@example.com')
        expect(build(:user, email: 'john@example.com')).not_to be_valid
      end
    end

    context 'password' do
      it { should validate_presence_of(:password) }
      it { should ensure_length_of(:password).is_at_least(6) }
      it { should validate_confirmation_of(:password) }
    end
  end
end