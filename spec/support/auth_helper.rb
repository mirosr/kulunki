module AuthHelper
  def fill_in_signin_form(username, password)
    fill_in 'Username or Email', with: username
    fill_in 'Password', with: password
    click_button 'Sign In'
  end

  def visit_protected(path)
    password = gen_secure_pass
    user = create(:user, password: password)
    
    visit_protected_path(path, user.username, password)
  end

  def visit_protected_as(path, create_params)
    if create_params[:password].nil?
      create_params[:password] = gen_secure_pass
    end
    password = create_params[:password]
    user = create(:user, create_params)
    
    visit_protected_path(path, user.username, password)
  end

  def visit_protected_as_user(path, user)
    visit_protected_path(path, user.username, gen_new_user_pass(user))
  end

  shared_examples 'a protected page' do |path_as_sym|
    let(:path) { send(path_as_sym) }

    context 'when user is not signed in' do
      it 'redirects the user to sign in' do
        visit path

        expect(current_path).to eq(signin_path)
        expect(page).to have_css 'form#new_session'
      end
    end
  end

  private
  
  def visit_protected_path(path, username, password)
    visit path

    fill_in_signin_form(username, password)
  end

  def gen_secure_pass
    FactoryGirl.generate(:secure_password)
  end

  def gen_new_user_pass(user)
    password = gen_secure_pass
    user.update_attributes!(password: password,
      password_confirmation: password)
    password
  end
end
