Feature: Users
  In order that the flowplace can have players
  As a player
  I want to be able to do the usual user things, like log in, change passwords, etc.
  
  Background:
    Given the default site configurations

  Scenario: a person with an account logs in
    Given I go to the login page
    Given I have an account
    And I log in
    Then I should be logged in
    And I should be taken to the dashboard page

  Scenario: a person without an account tries to log in
    When I log in
    Then I should not be logged in
    And I should see "Either we don't have an account with that name, or you've entered the wrong password. Please try again. (Remember that uppercase and lowercase matter in your password. Make sure your Caps Lock is not on.)"

    @allow-rescue
  Scenario: a user requests password reset, and then again to the same url again
    Given I have an account
    Then there should not be a reset code for "anonymous"
    When I go to the forgot password page
    And I fill in "E-mail Address" with "anonymous@harris-braun.com"
    And I press "Request Reset Password E-mail"
    Then there should be a reset code for "anonymous"
    When I go to the reset password page with the reset code for "anonymous"
#    Then what
    And I fill in "Choose a New Password" with "boingo"
    And I fill in "Confirm New Password" with "boingo"
    And I press "Change my password"
    Then I should be logged in
    And I should see "Your password was changed successfully. You are now signed in."
    When I go to the logout page
    When I go to the reset password page with the reset code for "anonymous"
    Then I should see "Invalid password reset token."

  Scenario: a user with two accounts with the same e-mail requests password reset
    Given I have an account
    Given A user "anonymous2" with email "anonymous@harris-braun.com"
    Then there should not be a reset code for "anonymous"
    And there should not be a reset code for "anonymous"
    When I go to the forgot password page
    And I fill in "E-mail address" with "anonymous@harris-braun.com"
    And I press "Request Reset Password E-mail"
    Then there should be a reset code for "anonymous"
    And there should be a reset code for "anonymous2"
    When I go to the reset password page with the reset code for "anonymous2"
    And I fill in "Choose a New Password" with "boingo"
    And I fill in "Confirm New Password" with "boingo"
    And I press "Change my password"
#    Then what
    Then I should be logged in
    And I should see "Your password was changed successfully. You are now signed in."
    When I go to the logout page
    When I go to the reset password page with the reset code for "anonymous"
    And I fill in "Choose a New Password" with "boingo"
    And I fill in "Confirm New Password" with "boingo"
    And I press "Change my password"
    Then I should be logged in
    And I should see "Your password was changed successfully. You are now signed in."

  Scenario: a user requests password reset but for an email that doesn't exist in the system
    When I go to the forgot password page
    And I fill in "E-mail address" with "anonymous@anonymous.org"
    And I press "Request Reset Password E-mail"
    Then I should see "We have no account associated with that e-mail address"

  Scenario: a user requests password reset without filling in an e-mail
    When I go to the forgot password page
    And I press "Request Reset Password E-mail"
    Then I should see "Please enter a valid e-mail"

  Scenario: a user creates and activates an account
    And I am logged into my "admin" account
    And I have "admin" privs
    When I go to the configurations page
    And I follow "New User Policy"
    And I select "self_signup" from "configuration_value"
    And I press "Update"
    When I go to the logout page
    And I go to the sign up page
    Then I should be taken to the sign up page
    And I fill in "Account name" with "jane"
    And I fill in "First name" with "Jane"
    And I fill in "Last name" with "Smith"
    And I fill in "E-mail" with "notifications@harris-braun.com"
    And I fill in "Password" with "password"
    And I fill in "Confirm Password" with "password"
    And I press "Sign up"
#    Then I should see "The account jane has been created and activation instructions were sent to notifications@harris-braun.com"
    When I go to the user activation page
    Then I should see "Your account has been activated. You are now signed in."

  Scenario: a user tries to create a password but mistypes password confirmation
    And I am logged into my "admin" account
    And I have "admin" privs
    When I go to the configurations page
    And I follow "New User Policy"
    And I select "self_signup" from "configuration_value"
    And I press "Update"
    When I go to the logout page
    And I go to the sign up page
    Then I should be taken to the sign up page
    And I fill in "Account name" with "jane"
    And I fill in "First name" with "Jane"
    And I fill in "Last name" with "Smith"
    And I fill in "E-mail" with "notifications@harris-braun.com"
    And I fill in "Password" with "password"
    And I fill in "Confirm Password" with "pasword"
    And I press "Sign up"
    Then what
    Then I should see "password mismatch"
          
  @allow-rescue
  Scenario: a user tries to sign up when self signup policy is off
    When I go to the sign up page
    Then I should be taken to the home page
    