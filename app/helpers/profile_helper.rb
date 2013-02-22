module ProfileHelper
  def household_name
    if current_user.household.present?
      current_user.household.name
    else
      'none'
    end
  end

  def co_members_list
    if current_user.co_members.any?
      current_user.co_members.map{ |m| m.username }.sort.join(', ')
    else
      'none'
    end
  end
end
