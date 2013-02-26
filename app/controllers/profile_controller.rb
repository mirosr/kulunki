class ProfileController < ApplicationController
  def show
  end

  def edit
    @profile = current_user
  end

  def update
    if current_user.update_personal_attributes(params[:user])
      redirect_to profile_path, notice: 'Your personal data was updated successfully'
    else
      current_user.reload
      @profile = current_user
      flash.now.alert = 'Your personal data failed to update'
      render :edit
    end
  end

  def change_password
    if User.authenticate(current_user.username, params[:current_password])
      current_user.password_confirmation = params[:password_confirmation]
      if current_user.change_password!(params[:password])
        redirect_to profile_path, notice: 'Your password was changed successfully'
      else
        @profile = current_user
        flash.now.alert = "The new passwords didn't matched"
        render :edit
      end
    else
      @profile = current_user
      flash.now.alert = 'Current password was incorrect'
      render :edit
    end
  end
end
