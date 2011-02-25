def create_user(user,email = nil)
  @user = User.find_by_user_name(user)
  if @user.nil?
    email ||= "#{user}@harris-braun.com"
    u = User.new({:user_name => user, :first_name => user.capitalize,:last_name => 'User',:email=>email,:password => 'password'})
    u.save
    u.update_attribute(:confirmation_token,nil)
    u.update_attribute(:confirmed_at,Time.now)
    @user = u
  end
  @user
end

Given /I am logged into my( "([^\"]*)")* account/ do |dummy,user|
  user ||= 'anonymous'
  user = %Q| as "#{user}"|
  Given "I have an account" + user
  Given "I log in"+ user
end


Given /^I log in( as "([^\"]*)")*$/ do |dummy,user|
  user ||= 'anonymous'
  Given "I go to the login page"
  Given %Q|I fill in "Account Name" with "#{user}"|
  Given 'I fill in "Password" with "password"'
  Given 'I press "Log in"'
end

Given /I have an account( as "([^\"]*)")*/ do |dummy,user|
  user ||= 'anonymous'
  create_user(user)
end

Given /^A user "([^\"]*)"$/ do |user|
  create_user(user)
end

Given /^A user "([^\"]*)" with email "([^\"]*)"/ do |user,email|
  create_user(user,email)
end

Then "I $should be logged in" do |should|
  controller.send(shouldify(should), be_logged_in)
end

Given /^I have "([^\"]*)" privs$/ do |priv_names|
  the_privs = []
  priv_names.split(/\W*,\W*/).each do |priv_name|
    the_privs << priv_name
  end
  @user.add_privs(the_privs)
end

Given /^I have checked the "([^\"]*)" preference$/ do |pref_name|
  When %Q|I go to the preferences page|
  And %Q|I check "prefs[#{pref_name}]"|
  And %Q|I press "Set Preferences"|
end

Given /I should be an "admin"/ do
  u = controller.current_user
  u.has_priv?(:admin).should == true
end

Then /I should have "(.*)" privs$/ do |priv_list|
  u = controller.current_user
  privs = priv_list.split(/\W*,\W*/)
  the_privs = u.get_privs
  privs.each {|p| the_privs.include?(p).should be_true}
end

Then /I should not have "(.*)" privs$/ do |priv_list|
  u = controller.current_user
  privs = priv_list.split(/\W*,\W*/)
  the_privs = u.get_privs
  privs.each {|p| the_privs.include?(p).should be_false}
end

Then /^there should be a reset code for "([^\"]*)"$/ do |user_name|
  u = User.find_by_user_name(user_name)
  u.reset_password_token.should_not be_nil
end

Then /^there should not be a reset code for "([^\"]*)"$/ do |user_name|
  u = User.find_by_user_name(user_name)
  u.reset_password_token.should be_nil
end

Given /^admin creates a user( "([^\"]*)")*$/ do |dummy,user_name|
  user_name ||= 'joe'
  When %Q|I go to the add user page|
  And %Q|I fill in "Account Name" with "#{user_name}"|
  And %Q|I fill in "First Name" with "#{user_name.capitalize}"|
  And %Q|I fill in "Last Name" with "User"|
  And %Q|I fill in "Email" with "#{user_name}@harris-braun.com"|
  And %Q|I fill in "Phone" with "123-456-789"|
  And %Q|I fill in "Address 1" with "123 Main St"|
  And %Q|I fill in "City" with "Smalltown"|
  And %Q|I fill in "Zip" with "12345"|
  And %Q|I fill in "Zip" with "12345"|
  And %Q|I press "Create"|
  u = User.find_by_user_name(user_name)
  u.attempt_set_password(:password => "password", :password_confirmation => "password")
  u.confirm!
end
