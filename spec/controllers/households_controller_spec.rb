require 'spec_helper'

describe HouseholdsController do
  describe 'GET #new' do
    context 'when user is not signed in' do
      it 'redirects to sign in url' do
        get :new

        expect(response).to redirect_to signin_path
      end
    end

    it 'renders the :new template' do
      login_user build_stubbed(:user)

      get :new

      expect(response).to be_success
      expect(response).to render_template :new
    end
  end
end
