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

  describe '.valid_email?' do
    context 'when input param matches the regexp' do
      it 'returns true' do
        return_value = User.valid_email?('john@example.com')

        expect(return_value).to be_a(TrueClass)
        expect(return_value).to be_true
      end
    end

    context 'when input param does not match the regexp' do
      it 'returns false' do
        return_value = User.valid_email?('john')

        expect(return_value).to be_a(FalseClass)
        expect(return_value).to be_false
      end
    end

    context 'when input param is blank' do
      it 'returns false' do
        return_value = User.valid_email?('')

        expect(return_value).to be_a(FalseClass)
        expect(return_value).to be_false
      end
    end
  end

  describe '.reset_password_token_expired?' do
    context 'when reset_password_token_expires_at is in the past' do
      it 'returns true' do
        user = create(:user_with_expired_reset_password_token)

        expect(User.reset_password_token_expired?(
          user.reset_password_token)).to be_true
      end
    end

    context 'when reset_password_token_expires_at is in the future' do
      it 'returns false' do
        user = create(:user_with_reset_password_token)

        expect(User.reset_password_token_expired?(
          user.reset_password_token)).to be_false
      end
    end

    context 'when reset_password_token_expires_at is nil' do
      it 'returns false' do
        user = create(:user)

        expect(User.reset_password_token_expired?(
          user.reset_password_token)).to be_false
      end
    end
  end
end
