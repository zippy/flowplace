Given /^a circle "([^\"]*)"$/ do |circle_name|
  @user ||= create_user('anonymous')
  CurrencyMembrane.create(@user,{:circle=>{:name => circle_name},:password=>'password',:confirmation=>'password',:email => 'test@test.com'})
end

When /^I check the box for "([^\"]*)"$/ do |user_name|
  user = User.find_by_user_name(user_name)
  When %Q|I check "users_#{user.id}"|
end

Given /^a circle "([^\"]*)" with members "([^\"]*)"$/ do |circle_name,member_list|
  Given %Q|a circle "#{circle_name}"| if Currency.find_by_name(circle_name).nil?
  members = member_list.split(/, */)
  members.each {|m| create_user(m) if User.find_by_user_name(m).nil?}
  When %Q|I go to the players page for "#{circle_name}"|
  Then %Q|I should be taken to the players page for "#{circle_name}"|
  When %Q|I select "Show all" from "search_on_main"|
  When %Q|I press "Search"|
  members.each do |m|
    When %Q|I check the box for "#{m}"|
  end
  When %Q|I select "member" from "player_class"|
  When %Q|I press "Submit"|
end
