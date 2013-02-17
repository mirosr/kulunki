require 'spec_helper'

describe SessionsController do
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
    it 'checks the user credentials' do
      controller.should_receive(:login).once.with('john', 'john123', nil)
      controller.should_receive(:logged_in?).once

      post :create, username: 'john', password: 'john123'
    end

    context 'when user credentials are valid' do
      before(:each) do
        controller.stub(:logged_in?){ true }

        post :create
      end

      it 'redirects to dashboard url' do
        expect(response).to redirect_to dashboard_url
      end

      it 'sets a notice message' do
        expect(flash[:notice]).not_to be_blank
      end
    end

    context 'when user credentials are not valid' do
      before(:each) do
        controller.stub(:logged_in?){ false }

        post :create
      end

      it 're-renders the :new template' do
        expect_to_render_new_template
      end

      it 'sets an alert message' do
        expect(flash[:alert]).not_to be_blank
      end
    end

    context 'when the user selects remember me' do
      it 'checks the user credentials' do
        controller.stub(:logged_in?){ true }

        controller.should_receive(:login).once.with('john', 'john123', '1')
        controller.should_receive(:logged_in?).once

        post :create, username: 'john', password: 'john123', remember_me: '1'
      end

      it 'sets the remember_me_token cookie' do
        create(:user, username: 'john', password: 'john123')

        post :create, username: 'john', password: 'john123', remember_me: '1'

        expect(cookies[:remember_me_token]).not_to be_blank
      end
    end
  end

  describe 'GET #destroy' do
    it 'destroys the user session' do
      controller.should_receive(:logout)

      get :destroy

      expect(session[:user_id]).to be_nil
    end

    it 'redirects to root url' do
      get :destroy

      expect(response).to redirect_to root_url
    end

    it 'sets a notice message' do
      get :destroy

      expect(flash[:notice]).not_to be_blank
    end
  end
end
