def create_user(user,email = nil)
  @user = User.find_by_user_name(user)
  if @user.nil?
    email ||= "#{user}@#{user}.org"
    u = User.new({:user_name => user, :first_name => user.capitalize,:last_name => 'User',:email=>email})
    u.create_bolt_identity(:user_name => :user_name,:password => 'password') && u.save
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

Given /^I have "([^\"]*)" privs$/ do |priv_names|
  Given "permissions setup"
  priv_names.split(/\W*,\W*/).each do |priv_name|
    @user.roles << Role.find_by_name(priv_name)
  end
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

Given /I should have "(.*)" privs$/ do |priv_names|
  u = controller.current_user
  roles = u.roles.collect(&:name)
  priv_names.split(/\W*,\W*/).each do |priv_name|
    roles.include?(priv_name).should == true
  end
end

Given /I should not have "(.*)" privs$/ do |priv_names|
  u = controller.current_user
  roles = u.roles.collect(&:name)
  priv_names.split(/\W*,\W*/).each do |priv_name|
    roles.include?(priv_name).should == false
  end
end

Then /^there should be a reset code for "([^\"]*)"$/ do |user_name|
  u = User.find_by_user_name(user_name)
  u.bolt_identity.reset_code.should_not be_nil
end

Then /^there should not be a reset code for "([^\"]*)"$/ do |user_name|
  u = User.find_by_user_name(user_name)
  u.bolt_identity.reset_code.should be_nil
end

Given /^admin creates a user( "([^\"]*)")*$/ do |dummy,user_name|
  user_name ||= 'joe'
  When %Q|I go to the add user page|
  And %Q|I fill in "Account Name" with "#{user_name}"|
  And %Q|I fill in "First Name" with "#{user_name.capitalize}"|
  And %Q|I fill in "Last Name" with "User"|
  And %Q|I fill in "Email" with "#{user_name}@user.org"|
  And %Q|I fill in "Phone" with "123-456-789"|
  And %Q|I fill in "Address 1" with "123 Main St"|
  And %Q|I fill in "City" with "Smalltown"|
  And %Q|I fill in "Zip" with "12345"|
  And %Q|I fill in "Zip" with "12345"|
  And %Q|I press "Create"|
  u = User.find_by_user_name(user_name)
  u.bolt_identity.password="password"
  u.bolt_identity.enabled = true
  u.bolt_identity.save.should == true
end
