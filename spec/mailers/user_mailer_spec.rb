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

    it 'sends the reset password token' do
      expect(mail.body.encoded).to include(user.reset_password_token)
    end
  end
end
