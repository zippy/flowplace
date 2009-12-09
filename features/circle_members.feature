Feature: circle members
  In order to for circle cohesion and transparence
  As a user
  I want to be able to see the members of the circles I'm in

  Background:
    Given I am logged into my account
    And a circle "the circle"
    Given A user "joe"
    Given A user "jane"
    When I go to the players page for "the circle"
    When I select "Show all" from "search_on_main"
    And I press "Search"
    And I check "users_1"
    And I check "users_3"
    And I check "users_4"
    When I select "member" from "player_class"
    And I press "Submit"
    And I go to the logout page

  Scenario: User goes to the members tab of a circle
    Given I am logged into my "joe" account
    When I follow "Members"
    Then I should be taken to the current circle members page
    Then I should see "Joe"
    And I should see "Jane"