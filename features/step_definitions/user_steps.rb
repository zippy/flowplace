def create_user(user)
  u = User.new({:user_name => user, :first_name => user.capitalize,:last_name => 'User',:email=>"#{user}@#{user}.org"})
  u.create_bolt_identity(:user_name => :user_name,:password => 'password') && u.save
  @user = u
  u
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

Given /A user "([^\"]*)"/ do |user|
  create_user(user)
end

Then "I $should be logged in" do |should|
  controller.send(shouldify(should), be_logged_in)
end

Given /permissions setup/ do
  unless @permissions_setup
    User::Permissions.each do |p|
      Permission.create(:name => p)
      r = Role.create!(:name => p)
      r.allowances.add(p)
    end
    @permissions_setup = true
  end
end

Given /^I have "([^\"]*)" privs$/ do |priv_name|
  Given "permissions setup"
  @user.roles << Role.find_by_name(priv_name)
end

Given /^I have checked the "([^\"]*)" preference$/ do |pref_name|
  When %Q|I go to the preferences page|
  And %Q|I check "prefs[#{pref_name}]"|
  And %Q|I press "Set Preferences"|
end

Given /I should be an "admin"/ do
  u = controller.current_user
  u.can?(:admin).should == true
end

Given /I should be a "(.*)"$/ do |role|
  u = controller.current_user
  u.send("#{role}?").should_not == nil
end

Then /^there should be a reset code for "([^\"]*)"$/ do |user_name|
  u = User.find_by_user_name(user_name)
  u.bolt_identity.reset_code.should_not be_nil
end

Then /^there should not be a reset code for "([^\"]*)"$/ do |user_name|
  u = User.find_by_user_name(user_name)
  u.bolt_identity.reset_code.should be_nil
end