class ProfileController < ApplicationController
  def show
    @household = Household.first
  end

  def edit
    @profile = current_user
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to profile_path, notice: 'Your personal data was updated successfully'
    else
      current_user.reload
      @profile = current_user
      flash.now.alert = 'Your personal data failed to update'
      render :edit
    end
  end
end
