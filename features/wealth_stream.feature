Feature: Wealth Stream
  In order that users can have an overview of the circles they are a part of
  As a player
  I want to be able to see the circle holoptiview

  Background:
    Given I am logged into my account
    And I have "circle" privs
    And a circle "the circle" with members "anonymous"

  Scenario: User looks at wealth stream
    When I go to the holoptiview page
    Then I should see "My Wealth"
#    Then I should see "My Intentions"
#    Then I should see "My Actions"
    Then I should see "My Activities"
