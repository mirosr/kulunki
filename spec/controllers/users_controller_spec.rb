require 'spec_helper'

describe UsersController do
  describe 'GET #new' do
    before(:each) { get :new }

    it 'renders the :new template with auth layout' do
      expect(response).to be_success
      expect(response).to render_template 'layouts/auth'
      expect(response).to render_template :new
    end

    it 'initializes a new @user' do
      expect(response).to be_success
      expect(assigns(:user)).to be_a(User)
    end
  end
end
