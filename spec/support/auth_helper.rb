module AuthHelper
  def visit_protected(path)
    password = FactoryGirl.generate(:secure_password)
    user = create(:user, password: password)
    
    visit path

    fill_in 'Username or Email', with: user.username
    fill_in 'Password', with: password
    click_button 'Sign In'
  end
end
