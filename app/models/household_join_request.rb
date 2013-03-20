class HouseholdJoinRequest < ActiveRecord::Base
  attr_accessible :user, :household

  validates :user_id, uniqueness: {scope: :household_id}
  validates :status, inclusion: {in: %w[pending accepted]}

  belongs_to  :user
  belongs_to  :household

  def pending?
    status == 'pending'
  end
end
