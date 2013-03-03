require 'spec_helper'

describe PasswordController do
  def expect_to_render_new_template
    expect(response).to be_success
    expect(response).to render_template 'layouts/auth'
    expect(response).to render_template :new
  end

  def expect_to_render_edit_template
    expect(response).to be_success
    expect(response).to render_template 'layouts/auth'
    expect(response).to render_template :edit
  end

  describe 'GET #new' do
    it 'renders the :new template with auth layout' do
      get :new

      expect_to_render_new_template
    end
  end

  describe 'POST #create' do
    it 'checks if the email is valid' do
      User.should_receive(:valid_email?).with('john@example.com').once

      post :create, email: 'john@example.com'
    end

    it 'checks if the email is existing' do
      User.should_receive(:find_by_email).with('john@example.com').once

      post :create, email: 'john@example.com'
    end

    context 'when the email is valid and existing' do
      let(:user_john) { build(:user, email: 'john@example.com') }

      before(:each) do
        User.stub(:find_by_email){ user_john }
      end

      it 'sends reset password instructions' do
        user_john.should_receive(:deliver_reset_password_instructions!).once

        post :create, email: 'john@example.com'
      end

      it 'redirects to password url' do
        post :create, email: 'john@example.com'

        expect(response).to redirect_to reset_password_url
      end

      it 'sets a notice message' do
        post :create, email: 'john@example.com'

        expect(flash[:notice]).not_to be_blank
      end
    end

    context 'when the email is not valid' do
      before(:each) do
        User.stub(:valid_email?){ false }

        post :create, email: 'invalid'
      end

      it 're-renders the :new template' do
        expect_to_render_new_template
      end

      it 'sets an alert message' do
        expect(flash[:alert]).not_to be_blank
      end
    end

    context 'when the email is not existing' do
      before(:each) do
        User.stub(:find_by_email){ nil }

        post :create, email: 'nonexisting@example.com'
      end

      it 'redirects to password url' do
        expect(response).to redirect_to reset_password_url
      end

      it 'sets a notice message' do
        expect(flash[:notice]).not_to be_blank
      end
    end
  end

  describe 'GET #edit' do
    it 'checks if the reset password token is valid' do
      User.should_receive(:load_from_reset_password_token).with('token_value').once

      get :edit, token: 'token_value'
    end

    context 'when reset password token is valid' do
      before(:each) do
        user = build(:user_with_reset_password_token)
        User.stub(:load_from_reset_password_token) { user }

        get :edit, token: 'valid_token'
      end

      it 'initializes an existing user' do
        expect(response).to be_success
        expect(assigns(:user)).to be_a(User)
      end

      it 'renders the :edit template with auth layout' do
        expect_to_render_edit_template
      end
    end

    context 'when reset password token is not valid' do
      before(:each) do
        User.stub(:load_from_reset_password_token) { nil }

        get :edit, token: 'invalid_token'
      end

      it 'does not initialize an existing user' do
        expect(assigns(:user)).to be_nil
      end

      it 'redirects to sign in url' do
        expect(response).to redirect_to signin_url
      end
    end

    context 'when reset password token has expired' do
      before(:each) do
        User.stub(:load_from_reset_password_token) { nil }
        User.stub(:reset_password_token_expired?) { true }

        get :edit, token: 'expired_token'
      end

      it 'does not initialize an existing user' do
        expect(assigns(:user)).to be_nil
      end

      it 'redirects to password url' do
        expect(response).to redirect_to reset_password_url
      end

      it 'sets an alert message' do
        expect(flash[:alert]).not_to be_blank
      end
    end
  end

  describe 'PUT #update' do
    it 'checks if the reset password token is valid' do
      User.should_receive(:load_from_reset_password_token).with('token_value').once

      put :update, token: 'token_value'
    end

    context 'when reset password token is valid' do
      let(:user) { build(:user_with_reset_password_token) }
      before(:each) { User.stub(:load_from_reset_password_token) { user } }

      it 'initializes an existing user' do
        put :update, token: 'valid_token',
          password: 'new secure password',
          password_confirmation: 'new secure password'

        expect(assigns(:user)).to be_a(User)
      end

      it 'changes the user password' do
        user.should_receive(:change_password!).with('new secure password').once

        put :update, token: 'valid_token',
          password: 'new secure password',
          password_confirmation: 'new secure password'
      end

      it 'redirects to root url' do
        put :update, token: 'valid_token',
          password: 'new secure password',
          password_confirmation: 'new secure password'

        expect(response).to redirect_to root_url
      end

      it 'sets a notice message' do
        put :update, token: 'valid_token',
          password: 'new secure password',
          password_confirmation: 'new secure password'

        expect(flash[:notice]).not_to be_blank
      end

      context 'when change password did not succeed' do
        it 're-renders the :edit template with auth layout' do
          user = build(:user_with_reset_password_token)
          User.stub(:load_from_reset_password_token) { user }

          put :update, token: 'valid_token',
            password: 'new secure password',
            password_confirmation: 'password123'

            expect_to_render_edit_template
        end
      end
    end

    context 'when reset password token is not valid' do
      before(:each) do
        User.stub(:load_from_reset_password_token) { nil }
        User.stub(:reset_password_token_expired?) { false }

        put :update, token: 'invalid_token'
      end

      it 'does not initialize an existing user' do
        expect(assigns(:user)).to be_nil
      end

      it 'redirects to sign in url' do
        expect(response).to redirect_to signin_url
      end
    end

    context 'when reset password token has expired' do
      before(:each) do
        User.stub(:load_from_reset_password_token) { nil }
        User.stub(:reset_password_token_expired?) { true }

        put :update, token: 'expired_token'
      end

      it 'does not initialize an existing user' do
        expect(assigns(:user)).to be_nil
      end

      it 'redirects to password url' do
        expect(response).to redirect_to reset_password_url
      end

      it 'sets an alert message' do
        expect(flash[:alert]).not_to be_blank
      end
    end
  end
end
