require 'spec_helper'

describe SessionsController do
  describe 'GET #new' do
    it 'renders the :new template with auth layout' do
      get :new

      expect(response).to be_success
      expect(response).to render_template 'layouts/auth'
      expect(response).to render_template :new
    end
  end
end
