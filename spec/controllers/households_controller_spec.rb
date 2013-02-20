require 'spec_helper'

describe HouseholdsController do
  def expect_to_render_new_template
    expect(response).to be_success
    expect(response).to render_template :new
  end

  describe 'GET #new' do
    context 'when user is not signed in' do
      it 'redirects to sign in url' do
        get :new

        expect(response).to redirect_to signin_path
      end
    end

    it 'initializes a household variable' do
      login_user build_stubbed(:user)

      get :new

      expect(assigns(:household)).to be_a(Household)
      expect(assigns(:household)).to be_new_record
    end

    it 'renders the :new template' do
      login_user build_stubbed(:user)

      get :new

      expect_to_render_new_template
    end
  end

  describe 'POST #create' do
    before (:each) do
      login_user build_stubbed(:user)

      @household = Household.new
      Household.should_receive(:new).once.with(instance_of(HashWithIndifferentAccess)){ @household }
    end
    
    context 'when form params are valid' do
      it 'creates a new household' do
        @household.should_receive(:save).once{ true }
        
        post :create, household: {}

        expect(response).to redirect_to profile_path
        expect(flash[:notice]).not_to be_blank
      end
    end

    context 'when form params are not valid' do
      it 're-renders the :new template' do
        @household.should_receive(:save).once{ false }
        
        post :create, household: {}

        expect_to_render_new_template
      end
    end
  end
end
