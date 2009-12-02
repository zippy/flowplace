Feature: Wealth Stream
  In order that users can have an overview of the system
  As a player
  I want to be able to see it all

  Background:
    Given I am logged into my account

  Scenario: User looks at wealth stream
    When I go to the home page
    Then I should see "My Wealth"
    Then I should see "My Intentions"
    Then I should see "My Actions"
    Then I should see "My Activities"
