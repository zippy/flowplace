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
