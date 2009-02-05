module CirclesHelper
  def users_select(circle, opts = {})
    members = circle.users
    users = User.find(:all, :order => 'last_name, first_name').reject{|u| members.include?(u)}
    select_tag(:user_id, options_for_select([['-','']] + users.collect{|u| [u.full_name,u.id]}), opts)
  end
end
