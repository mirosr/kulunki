class UsersController < ApplicationController
  layout 'auth', only: :new

  def new
    @user = User.new
  end
end
