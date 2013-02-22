class HouseholdsController < ApplicationController
  def new
    @household = Household.new
  end

  def create
    @household = Household.new(params[:household])
    @household.head = current_user
    if @household.save
      current_user.household = @household
      current_user.save
      redirect_to profile_path, notice: 'Your household was created successfully'
    else
      flash.now.alert = 'The following errors prevent your household of being saved:'
      render :new
    end
  end
end
