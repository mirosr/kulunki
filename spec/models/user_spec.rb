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
    it { should allow_mass_assignment_of(:full_name) }
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

  describe 'associations' do
    it { should belong_to(:household) }

    describe 'co-members' do
      it { should have_many(:co_members) }

      it 'returns all household members without self' do
        members = create(:household_with_members).members
        co_members = members.first.co_members

        expect(co_members.count).to eq(members.count - 1)
        members.shift
        expect(co_members).to eq(members)
      end
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

  describe '.available_email?' do
    context 'when there is no user with the given email' do
      it 'returns true' do
        return_value = User.available_email?('john@example.com')

        expect(return_value).to be_a(TrueClass)
        expect(return_value).to be_true
      end
    end

    context 'when there is an user with the given email' do
      it 'returns false' do
        create(:user, email: 'john@example.com')

        return_value = User.available_email?('john@example.com')

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

  describe '.load_from_change_email_token' do
    context 'when token is valid' do
      it 'returns an user' do
        user = create(:user_with_change_email_token)

        expect(User.load_from_change_email_token(
          user.change_email_token)).to eq(user)
      end
    end

    context 'when token is not valid' do
      it 'returns nil' do
        user = create(:user_with_change_email_token)

        expect(User.load_from_change_email_token('invalid_token')).to be_nil
      end
    end
    
    context 'when token has expired' do
      it 'returns nil' do
        user = create(:user_with_expired_change_email_token)

        expect(User.load_from_change_email_token(
          user.change_email_token)).to be_nil
      end
    end
  end

  describe '.change_email_token_expired?' do
    context 'when change_email_token_expires_at is in the past' do
      it 'returns true' do
        user = create(:user_with_expired_change_email_token)

        expect(User.change_email_token_expired?(
          user.change_email_token)).to be_true
      end
    end

    context 'when change_email_token_expires_at is in the future' do
      it 'returns false' do
        user = create(:user_with_change_email_token)

        expect(User.change_email_token_expired?(
          user.change_email_token)).to be_false
      end
    end

    context 'when change_email_token_expires_at is nil' do
      it 'returns false' do
        user = create(:user)

        expect(User.change_email_token_expired?(
          user.change_email_token)).to be_false
      end
    end
  end

  describe '#admin?' do
    context 'when the user role is admin' do
      it 'returns true' do
        expect(build(:user, :admin).admin?).to be_true
      end
    end

    context 'when the user role is not admin' do
      it 'returns false' do
        expect(build(:user).admin?).to be_false
      end
    end
  end

  describe '#needs_to_be_admin?' do
    context 'when there are no users yet' do
      it 'returns true' do
        expect(User.new.needs_to_be_admin?).to be_true
      end
    end

    context 'when there are some users' do
      it 'returns false' do
        create(:user, :admin)

        expect(User.new.needs_to_be_admin?).to be_false
      end
    end
  end

  describe '#set_to_be_admin' do
    it 'sets an admin role' do
      user = User.new

      user.set_to_be_admin

      expect(user).to be_admin
    end
  end

  describe '#update_personal_attributes' do
    it 'updates only username and full_name' do
      user = build_stubbed(:user)
      user.should_receive(:update_attributes).with(
        username: 'john', full_name: 'John Doe').once

      user.update_personal_attributes(attributes_for(
        :user, username: 'john', full_name: 'John Doe'))
    end
  end

  describe '#deliver_change_email_instructions!' do
    let(:user) { build_stubbed(:user) }

    context 'when model can be saved' do
      before(:each) do
        User.should_receive(:available_email?).with(
          'john@example.com').once { true }
        user.should_receive(:save) { true }
      end

      it 'updates change email db fields' do
        current_token = generate(:sorcery_random_token)
        after_48h = Time.now.in_time_zone + 172800
        Sorcery::Model::TemporaryToken.should_receive(:generate_random_token) { current_token }

        user.deliver_change_email_instructions!('john@example.com')

        expect(user.change_email_token).to eq(current_token)
        expect(user.change_email_token_expires_at).to be > after_48h
        expect(user.change_email_new_value).to eq('john@example.com')
      end

      it 'sends change email instructions' do
        mail = double
        UserMailer.should_receive(:change_email_address_email).with(user).once { mail }
        mail.should_receive(:deliver)

        user.deliver_change_email_instructions!('john@example.com')
      end

      it 'returns true' do
        mail = double
        mail.stub(:deliver)
        UserMailer.stub(:change_email_address_email) { mail }

        expect(user.deliver_change_email_instructions!(
          'john@example.com')).to be_true
      end
    end

    context 'when model can not be saved' do
      before(:each) do
        User.should_receive(:available_email?).once { true }
        user.should_receive(:save) { false }
      end

      it 'clears change email db fields' do
        user.deliver_change_email_instructions!('john@example.com')

        expect(user.change_email_token).to be_nil
        expect(user.change_email_token_expires_at).to be_nil
        expect(user.change_email_new_value).to be_nil
      end

      it 'does not send change email instructions' do
        UserMailer.should_not_receive(:change_email_address_email).with(user)

        user.deliver_change_email_instructions!('john@example.com')
      end

      it 'returns false' do
        mail = double
        mail.stub(:deliver)
        UserMailer.stub(:change_email_address_email) { mail }

        expect(user.deliver_change_email_instructions!('')).to be_false
      end
    end

    context 'when the new email is not available' do
      before(:each) do
        User.should_receive(:available_email?).with(
          'john@example.com').once { false }
        user.should_not_receive(:save)
      end

      it 'does not update change email db fields' do
        user.deliver_change_email_instructions!('john@example.com')

        expect(user.change_email_token).to be_nil
        expect(user.change_email_token_expires_at).to be_nil
        expect(user.change_email_new_value).to be_nil
      end

      it 'does not send change email instructions' do
        UserMailer.should_not_receive(:change_email_address_email).with(user)

        user.deliver_change_email_instructions!('john@example.com')
      end

      it 'returns false' do
        expect(user.deliver_change_email_instructions!(
          'john@example.com')).to be_false
      end
    end
  end

  describe '#change_email' do
    context 'when change email token is set' do
      it 'updates only email attribute' do
        user = build_stubbed(:user_with_change_email_token,
          change_email_new_value: 'john@example.com')
        user.should_receive(:email=).with('john@example.com').once
        user.should_receive(:save).once

        user.change_email
      end

      it 'clears the change email token' do
        user = build_stubbed(:user_with_change_email_token)
        user.stub(:save) { true }

        user.change_email

        expect(user.change_email_token).to be_nil
        expect(user.change_email_token_expires_at).to be_nil
      end
    end

    context 'when change email token is not set' do
      it 'does not update the email attribute' do
        user = build_stubbed(:user, email: 'john@example.com')
        user.should_not_receive(:email=)
        user.should_not_receive(:save)

        user.change_email

        expect(user.email).to eq('john@example.com')
      end
    end
  end
end
