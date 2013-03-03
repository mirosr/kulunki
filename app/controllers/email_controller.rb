class EmailController < ApplicationController
  skip_before_filter :require_login

  def update
    user = User.load_from_change_email_token(params[:token])
    if user.present?
      user.change_email
      user.reload
      redirect_to signin_url, notice: "Your email has been changed to #{user.email}"
    else
      if User.change_email_token_expired?(params[:token])
        redirect_to signin_path, alert: 'Sorry, this change email token has expited. Please request a new one.'
      else
        not_authenticated
      end
    end
  end
end
