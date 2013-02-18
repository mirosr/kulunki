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
end
