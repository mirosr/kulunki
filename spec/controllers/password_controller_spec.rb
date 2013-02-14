require 'spec_helper'

describe PasswordController do
  def expect_to_render_new_template
    expect(response).to be_success
    expect(response).to render_template 'layouts/auth'
    expect(response).to render_template :new
  end

  describe 'GET #new' do
    it 'renders the :new template with auth layout' do
      get :new

      expect_to_render_new_template
    end
  end

  describe 'POST #create' do
    it 'checks if the email is valid' do
      User.should_receive(:valid_email?).with('john@example.com')

      post :create, email: 'john@example.com'
    end

    it 'checks if the email is existing' do
      User.should_receive(:find_by_email).with('john@example.com')

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
    it 'renders the :edit template with auth layout' do
      get :edit, token: 'token_value'

      expect(response).to be_success
      expect(response).to render_template 'layouts/auth'
      expect(response).to render_template :edit
    end

    it 'sets token param' do
      get :edit, token: 'token_value'

      expect(controller.params[:token]).to eq('token_value')
    end
  end
end
