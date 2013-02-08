class UsersController < ApplicationController
  layout 'auth', only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      auto_login(@user)
      redirect_to dashboard_path, notice: 'Welcome to Kulunki, john.'
    else
      render :new
    end
  end
end
