require 'spec_helper'

describe PasswordController do
  describe 'GET #reset' do
    it 'renders the :reset template with auth layout' do
      get :reset

      expect(response).to be_success
      expect(response).to render_template 'layouts/auth'
      expect(response).to render_template :reset
    end
  end
end
