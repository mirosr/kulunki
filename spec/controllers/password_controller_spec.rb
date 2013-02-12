require 'spec_helper'

describe PasswordController do
  def expect_to_render_edit_template
    expect(response).to be_success
    expect(response).to render_template 'layouts/auth'
    expect(response).to render_template :edit
  end

  describe 'GET #edit' do
    it 'renders the :edit template with auth layout' do
      get :edit

      expect_to_render_edit_template
    end
  end

  describe 'POST #update' do
    it 'checks if the email is valid' do
      User.should_receive(:valid_email?).with('john@example.com')

      post :update, email: 'john@example.com'
    end

    it 'checks if the email is existing' do
      User.should_receive(:find_by_email).with('john@example.com')

      post :update, email: 'john@example.com'
    end

    context 'when the email is valid and existing' do
      before(:each) do
        User.stub(:find_by_email){ true }

        post :update, email: 'john@example.com'
      end

      it 'redirects to password url' do
        expect(response).to redirect_to password_reset_url
      end

      it 'sets a notice message' do
        expect(flash[:notice]).not_to be_blank
      end
    end

    context 'when the email is not valid' do
      before(:each) do
        User.stub(:valid_email?){ false }

        post :update, email: 'invalid'
      end

      it 're-renders the :edit template' do
        expect_to_render_edit_template
      end

      it 'sets an alert message' do
        expect(flash[:alert]).not_to be_blank
      end
    end

    context 'when the email is not existing' do
      before(:each) do
        User.stub(:find_by_email){ false }

        post :update, email: 'nonexisting@example.com'
      end

      it 'redirects to password url' do
        expect(response).to redirect_to password_reset_url
      end

      it 'sets a notice message' do
        expect(flash[:notice]).not_to be_blank
      end
    end
  end
end
