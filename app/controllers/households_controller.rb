class HouseholdsController < ApplicationController
  def new
    @household = Household.new
  end

  def create
    @household = Household.new(params[:household])
    if @household.save
      redirect_to profile_path, notice: 'Your household was created successfully'
    else
      flash.now.alert = 'The following errors prevent your household of being saved:'
      render :new
    end
  end
end
