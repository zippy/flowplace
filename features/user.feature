Feature: Users
  In order that the system can have players
  As a player
  I want there to be users!

  Scenario: logging in as a user with an account
    Given I have an account
    And I log in
    Then I should be logged in
    And I should be taken to the my wealth stream page

  Scenario: logging in as a user without an account
    When I log in
    Then I should not be logged in
    And I should see "Either we don't have an account with that name, or you've entered the wrong password.  Please try again."
