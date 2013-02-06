require 'spec_helper'

describe UsersController do
  describe 'GET #new' do
    before(:each) { get :new }

    it 'renders the :new template with auth layout' do
      expect(response).to be_success
      expect(response).to render_template 'layouts/auth'
      expect(response).to render_template :new
    end

    it 'initializes a new user' do
      expect(response).to be_success
      expect(assigns(:user)).to be_a(User)
    end
  end

  describe 'POST #create' do
    before (:each) do
      @user = User.new

      User.should_receive(:new).once.with(instance_of(HashWithIndifferentAccess)){ @user }
    end
    
    it 'creates a new user with valid params' do
      @user.should_receive(:save).once{ true }
      
      post :create, user: {}

      expect(response).to redirect_to dashboard_path
      expect(flash[:notice]).not_to be_blank
    end

    it 're-renders the :new template when there are errors' do
      @user.should_receive(:save).once{ false }
      
      post :create, user: {}

      expect(response).to be_success
      expect(response).to render_template :new
    end
  end
end
