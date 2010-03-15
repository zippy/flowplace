Feature: circle members
  In order to for circle cohesion and transparence
  As a user
  I want to be able to see the members of the circles I'm in

  Background:
    Given I am logged into my account
    And I have "circle" privs
    Given a circle "the circle" with members "joe,jane"
    And I go to the logout page

  Scenario: User goes to the members tab of a circle
    Given I am logged into my "joe" account
    When I follow "Members"
    Then I should be taken to the current circle members page
    Then I should see "Joe"
    And I should see "Jane"