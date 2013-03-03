require 'spec_helper'

describe ProfileController do
  describe 'GET #show' do
    context 'when user is not signed in' do
      it 'redirects to sign in url' do
        get :show

        expect(response).to redirect_to signin_path
      end
    end

    it 'renders the :show template' do
      login_user build_stubbed(:user)

      get :show

      expect(response).to be_success
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    context 'when user is not signed in' do
      it 'redirects to sign in url' do
        get :edit

        expect(response).to redirect_to signin_path
      end
    end

    it 'renders the :edit template' do
      login_user build_stubbed(:user)

      get :edit

      expect(response).to be_success
      expect(response).to render_template :edit
    end
  end

  describe 'PUT #update' do
    context 'when form params are valid' do
      let(:current_user) { current_user = build_stubbed(:user) }
      before(:each) do
        current_user.stub(:update_personal_attributes) { true }
        login_user current_user
      end

      it 'updates the user' do
        current_user.should_receive(
          :update_personal_attributes).with(
          'username' => 'john', 'full_name' => 'John Doe').once

        put :update, user: {username: 'john', full_name: 'John Doe'}
      end

      it 'redirects to profile url' do
        put :update

        expect(response).to redirect_to profile_path
      end

      it 'sets a notice message' do
        put :update

        expect(flash[:notice]).not_to be_nil
      end
    end

    context 'when form params are invalid' do
      let(:current_user) { build_stubbed(:user) }
      before(:each) do
        current_user.stub(:update_personal_attributes) { false }
        current_user.stub(:reload) { true }
        login_user current_user

        put :update, user: {username: ''}
      end

      it 're-renders the :edit template' do
        expect(response).to be_success
        expect(response).to render_template :edit
      end

      it 'sets an alert message' do
        expect(flash[:alert]).not_to be_blank
      end
    end
  end

  describe 'PUT #change_password' do
    context 'when form params are valid' do
      it 'changes the user password' do
        current_user = build_stubbed(:user,
          username: 'john', password: 'old_password')
        User.should_receive(:authenticate).with('john', 'old_password').once { current_user }
        current_user.stub(:change_password!).with(
          'new_password').once { true }
        login_user current_user

        put :change_password, current_password: 'old_password',
          password: 'new_password',
          password_confirmation: 'new_password'
      end

      it 'redirects to profile url' do
        current_user = build_stubbed(:user)
        User.should_receive(:authenticate) { current_user }
        current_user.stub(:change_password!) { true }
        login_user current_user

        put :change_password

        expect(response).to redirect_to profile_path
      end

      it 'sets a notice message' do
        current_user = build_stubbed(:user)
        User.should_receive(:authenticate) { current_user }
        current_user.stub(:change_password!) { true }
        login_user current_user

        put :change_password

        expect(flash[:notice]).not_to be_nil
      end
    end

    context 'when the current password is invalid' do
      let(:current_user) { build_stubbed(:user) }
      before(:each) do
        User.should_receive(:authenticate) { nil }
        login_user current_user

        put :change_password
      end

      it 're-renders the :edit template' do
        expect(response).to be_success
        expect(response).to render_template :edit
      end

      it 'sets an alert message' do
        expect(flash[:alert]).not_to be_blank
      end
    end

    context 'when new passwords do not match' do
      let(:current_user) { build_stubbed(:user) }
      before(:each) do
        User.should_receive(:authenticate) { current_user }
        current_user.stub(:change_password!).with(
          'new_password').once { false }
        current_user.should_receive(:reload)
        login_user current_user

        put :change_password, password: 'new_password',
          password_confirmation: 'new_password'
      end

      it 're-renders the :edit template' do
        expect(response).to be_success
        expect(response).to render_template :edit
      end

      it 'sets an alert message' do
        expect(flash[:alert]).not_to be_blank
      end
    end
  end

  describe 'PUT #change_email' do
    context 'when form params are valid' do
      it 'sends the change email instructions' do
        current_user = build_stubbed(:user, username: 'john',
          password: 'john123')
        User.should_receive(:authenticate).with(
          'john', 'john123').once { current_user }
        User.should_receive(:valid_email?).with(
          'john@example.com').once { true }
        current_user.should_receive(
          :deliver_change_email_instructions!).with(
          'john@example.com').once { true }
        login_user current_user

        put :change_email, email: 'john@example.com', password: 'john123'
      end

      it 'redirects to profile url' do
        current_user = build_stubbed(:user)
        User.should_receive(:authenticate) { current_user }
        User.should_receive(:valid_email?).once { true }
        current_user.stub(:deliver_change_email_instructions!) { true }
        login_user current_user

        put :change_email

        expect(response).to redirect_to profile_path
      end

      it 'sets a notice message' do
        current_user = build_stubbed(:user)
        User.should_receive(:authenticate) { current_user }
        User.should_receive(:valid_email?).once { true }
        current_user.stub(:deliver_change_email_instructions!) { true }
        login_user current_user

        put :change_email

        expect(flash[:notice]).not_to be_nil
      end
    end

    context 'when the email is invalid' do
      let(:current_user) { build_stubbed(:user) }
      before(:each) do
        User.should_receive(:authenticate) { current_user }
        User.should_receive(:valid_email?).once { false }
        login_user current_user

        put :change_email
      end

      it 're-renders the :edit template' do
        expect(response).to be_success
        expect(response).to render_template :edit
      end

      it 'sets an alert message' do
        expect(flash[:alert]).not_to be_blank
      end
    end

    context 'when the email is already taken' do
      let(:current_user) { current_user = build_stubbed(:user) }
      before(:each) do
        User.should_receive(:authenticate).once { current_user }
        User.should_receive(:valid_email?).once { true }
        current_user.should_receive(
          :deliver_change_email_instructions!).with(
          'john@example.com').once { false }
        login_user current_user

        put :change_email, email: 'john@example.com'
      end

      it 're-renders the :edit template' do
        expect(response).to be_success
        expect(response).to render_template :edit
      end

      it 'sets an alert message' do
        expect(flash[:alert]).not_to be_blank
      end
    end

    context 'when the password is invalid' do
      let(:current_user) { build_stubbed(:user) }
      before(:each) do
        User.should_receive(:authenticate) { nil }
        login_user current_user

        put :change_email
      end

      it 're-renders the :edit template' do
        expect(response).to be_success
        expect(response).to render_template :edit
      end

      it 'sets an alert message' do
        expect(flash[:alert]).not_to be_blank
      end
    end
  end
end
