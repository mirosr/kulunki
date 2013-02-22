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

    it 'initializes the profile of current_user' do
      current_user = build_stubbed(:user)
      login_user current_user

      get :edit

      expect(assigns(:profile)).to eq(current_user)
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
        current_user.stub(:update_attributes) { true }
        login_user current_user
      end

      it 'updates the user' do
        current_user.should_receive(
          :update_attributes).with(
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
        current_user.stub(:update_attributes) { false }
        current_user.stub(:reload) { true }
        login_user current_user

        put :update, user: {username: ''}
      end

      it 'initializes the profile of current_user' do
        expect(assigns(:profile)).to eq(current_user)
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
