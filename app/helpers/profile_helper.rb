module ProfileHelper
  def co_members_list
    if current_user.co_members.any?
      current_user.co_members.map{ |m| m.username }.sort.join(', ')
    else
      'none'
    end
  end
end
