class HouseholdJoinRequest < ActiveRecord::Base
  attr_accessible :user_id, :household_id, :status
end
