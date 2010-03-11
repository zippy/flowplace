Feature: Users
  In order that the flowplace can have players
  As a player
  I want to be able to log in

  Scenario: a person with an account logs in
    Given I have an account
    And I log in
    Then I should be logged in
    And I should be taken to the dashboard page

  Scenario: a person without an account tries to log in
    When I log in
    Then I should not be logged in
    And I should see "Either we don't have an account with that name, or you've entered the wrong password. Please try again. (Remember that uppercase and lowercase matter in your password. Make sure your Caps Lock is not on.)"

  Scenario: a user requests password reset
    Given I have an account
    When I go to the forgot password page
    Then there should not be a reset code for "anonymous"
    And I fill in "E-mail address" with "anonymous@anonymous.org"
    And I press "Request Reset Password E-mail"
    Then there should be a reset code for "anonymous"
    When I go to the reset password page with the reset code for "anonymous"
    And I fill in "Choose a New Password" with "boingo"
    And I fill in "Confirm New Password" with "boingo"
    And I press "Reset Password"
    Then I should be logged in
    
