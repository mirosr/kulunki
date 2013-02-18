class UsersController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]

  layout 'auth', only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.needs_to_be_admin?
      @user.set_to_be_admin
      alert = 'You are the first user, so an admin role was granted to you'
    end
    if @user.save
      auto_login(@user)
      redirect_to dashboard_path,
        notice: "Welcome to Kulunki, #{@user.username}",
        alert: alert
    else
      render :new
    end
  end
end
