require 'spec_helper'

describe UsersController do
  def expect_to_render_new_template
    expect(response).to be_success
    expect(response).to render_template 'layouts/auth'
    expect(response).to render_template :new
  end

  describe 'GET #new' do
    before(:each) { get :new }

    it 'renders the :new template with auth layout' do
      expect_to_render_new_template
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
    
    context 'when form params are valid' do
      it 'creates a new user' do
        @user.should_receive(:save).once{ true }
        controller.should_receive(:auto_login).once.with(@user)
        
        post :create, user: {}

        expect(response).to redirect_to dashboard_path
        expect(flash[:notice]).not_to be_blank
      end
    end

    context 'when form params are not valid' do
      it 're-renders the :new template' do
        @user.should_receive(:save).once{ false }
        
        post :create, user: {}

        expect_to_render_new_template
      end
    end
  end
end
