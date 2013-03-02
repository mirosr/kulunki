class UserMailer < ActionMailer::Base
  default from: 'from@example.com'

  def reset_password_email(user)
    @user = user
    @url = change_password_url(@user.reset_password_token)

    mail to: user.email, subject: 'Reset Password'
  end

  def change_email_address_email(user)
    @user = user
    @url = change_email_url(@user.change_email_token)

    mail to: user.change_email_new_value, subject: 'Change Email Address'
  end
end
