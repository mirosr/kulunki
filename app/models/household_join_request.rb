class HouseholdJoinRequest < ActiveRecord::Base
  attr_accessible :user, :household

  validates :user_id, uniqueness: {scope: :household_id}

  belongs_to  :user
  belongs_to  :household
end
