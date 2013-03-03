require 'spec_helper'

describe EmailController do
  describe 'GET #update' do
    context 'when reset email token is valid' do
      let(:user) { build(:user_with_change_email_token) }
      before(:each) do
        User.should_receive(:load_from_change_email_token) { user }
        user.should_receive(:reload)
      end

      it 'changes the user email' do
        user.should_receive(:change_email).once

        get :update, token: 'valid_token'
      end

      it 'redirects to signin url' do
        get :update, token: 'valid_token'

        expect(response).to redirect_to signin_path
      end

      it 'sets a notice message' do
        get :update, token: 'valid_token'

        expect(flash[:notice]).not_to be_blank
      end
    end

    context 'when change email token is not valid' do
      before(:each) do
        User.should_receive(:load_from_change_email_token) { nil }
        User.should_receive(:change_email_token_expired?) { false }

        get :update, token: 'invalid_token'
      end

      it 'redirects to sign in url' do
        expect(response).to redirect_to signin_url
      end

      it 'does not set a notice message' do
        expect(flash[:notice]).to be_blank
      end
    end

    context 'when change email token has expired' do
      before(:each) do
        User.should_receive(:load_from_change_email_token) { nil }
        User.should_receive(:change_email_token_expired?) { true }

        get :update, token: 'expired_token'
      end

      it 'redirects to signin url' do
        expect(response).to redirect_to signin_path
      end

      it 'sets an alert message' do
        expect(flash[:alert]).not_to be_blank
      end
    end
  end
end
