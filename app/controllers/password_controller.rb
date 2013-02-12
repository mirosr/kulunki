class PasswordController < ApplicationController
  layout 'auth'

  def edit
  end

  def update
    if User.valid_email?(params[:email])
      User.find_by_email(params[:email])
      redirect_to password_reset_url, notice: 'An email with instructions was sent to you'
    else
      flash.now.alert = 'The email address you provided was invalid. Please try again.'
      render :edit
    end
  end
end
