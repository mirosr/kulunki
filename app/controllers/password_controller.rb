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
  end

  def update
  end
end
