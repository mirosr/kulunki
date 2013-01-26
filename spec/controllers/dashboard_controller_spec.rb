require 'spec_helper'

describe DashboardController do
  describe 'GET #show' do
    it 'renders the :show template' do
      get :show

      expect(response).to be_success
      expect(response).to render_template :show
    end
  end
end
