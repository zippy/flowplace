def create_user(user)
  u = User.new({:user_name => user, :first_name => 'Joe',:last_name => user.capitalize,:email=>"#{user}@#{user}.org"})
  u.create_bolt_identity(:user_name => :user_name,:password => 'password') && u.save
  u
end

Given /I am on the login page/ do
  visit "/login"
end

Given /I have an account/ do
  create_user('user')
end

Given /I am logged in/ do
  user = create_user('user')
  controller.current_user = user
end

Then "I $should be logged in" do |should|
  controller.send(shouldify(should), be_logged_in)
end
