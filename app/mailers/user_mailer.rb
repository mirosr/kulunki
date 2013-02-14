class UserMailer < ActionMailer::Base
  default from: 'from@example.com'

  def reset_password_email(user)
    @user = user
    @url = change_password_url(@user.reset_password_token)

    mail to: user.email, subject: 'Reset Password'
  end
end
