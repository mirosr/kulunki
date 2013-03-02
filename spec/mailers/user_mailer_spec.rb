require 'spec_helper'

describe UserMailer do
  describe 'reset_password_email' do
    let(:user) { build(:user, reset_password_token: 'token_value') }
    let(:mail) { UserMailer.reset_password_email(user) }

    it 'renders the headers' do
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq('Reset Password')
    end

    it 'addresses user by his username' do
      expect(mail.body.encoded).to include(user.username)
    end

    it 'sends the change password url' do
      expect(mail.body.encoded).to include(
        change_password_url(user.reset_password_token))
    end
  end

  describe 'change_email_address_email' do
    let(:user) do
      build(:user, change_email_token: 'token_value',
        change_email_new_value: 'john.doe@example.com')
    end
    let(:mail) { UserMailer.change_email_address_email(user) }

    it 'renders the headers' do
      expect(mail.from).to eq(['from@example.com'])
      expect(mail.to).to eq(['john.doe@example.com'])
      expect(mail.subject).to eq('Change Email Address')
    end

    it 'addresses user by his username' do
      expect(mail.body.encoded).to include(user.username)
    end

    it 'sends the change email url' do
      expect(mail.body.encoded).to include(
        change_email_url(user.change_email_token))
    end
  end
end
