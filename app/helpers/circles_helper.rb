module CirclesHelper
  def users_select(circle, opts = {})
    members = circle.users
    users = User.find(:all, :order => 'last_name, first_name').reject{|u| members.include?(u)}
    users_select_tag(users,opts)
  end
  
  def user_currencies(circle,user)
    circle.currencies.collect do |c|
      c.name+'<br />'+c.api_player_classes.join(',')
    end.join('')
  end
end
