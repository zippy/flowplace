def create_user(user)
  u = User.new({:user_name => user, :first_name => user.capitalize,:last_name => 'User',:email=>"#{user}@#{user}.org"})
  u.create_bolt_identity(:user_name => :user_name,:password => 'password') && u.save
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

Then "I $should be logged in" do |should|
  controller.send(shouldify(should), be_logged_in)
end
