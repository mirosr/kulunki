class PasswordController < ApplicationController
  layout 'auth'

  def new
  end

  def create
    if User.valid_email?(params[:email])
      user = User.find_by_email(params[:email])
      user.deliver_reset_password_instructions! if user.present?
      redirect_to reset_password_url, notice: 'An email with instructions was sent to you'
    else
      flash.now.alert = 'The email address you provided was invalid. Please try again.'
      render :new
    end
  end

  def edit
    user = User.load_from_reset_password_token(params[:token])
    if user.nil?
      if User.reset_password_token_expired?(params[:token])
        redirect_to reset_password_url, alert: 'Sorry, this reset password token has expited. Please request a new one.'
      else
        not_authenticated
      end
    end
  end

  def update
  end
end
