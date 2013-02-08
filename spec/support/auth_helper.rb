module AuthHelper
  def visit_protected(path)
    password = FactoryGirl.generate(:secure_password)
    user = create(:user, password: password)
    
    visit path

    fill_in 'Username or Email', with: user.username
    fill_in 'Password', with: password
    click_button 'Sign In'
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
end
