class SessionsController < ApplicationController
  layout 'auth'

  def new
  end

  def create
    login(params[:username], params[:password], params[:remember_me])
    if logged_in?
      redirect_back_or_to dashboard_url, notice: 'Signed in successfully'
    else
      flash.now.alert = 'Username or email or password was incorrect'
      render :new
    end
  end
end
