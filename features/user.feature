Feature: Users
  In order that the system can have players
  As a player
  I want there to be users!

  Scenario: Logged in
		Given I have an account
	  And I am on the login page
	  And I fill in "Account Name" with "user"
	  And I fill in "Password" with "password"
		And I press "Log in"
		Then I should be logged in

