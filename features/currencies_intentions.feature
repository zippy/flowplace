Feature: intentions currency
  In order to facilitate awareness of and matching of inentions
  As a player
  I want to be able to place and see others intentions

  Background:
    Given I am logged into my account
    Given I have "circle,currency" privs
    Given a circle "the circle"
    When I go to the new "Intentions" currencies page
    Then I should be taken to the new "Intentions" currencies page
    When I fill in "Name" with "Wealing"
    And I press "Create"
    Then I should be taken to the currencies page
    And I should see "Wealing"
    And I bind "Wealing" to "the circle"
    And A user "joe"
    And A user "jane"
    When I make "joe" a "member" of "the circle"
    When I make "jane" a "member" of "the circle"
    Given "jane" is a "member" of currency "Wealing"
    Given "joe" is a "member" of currency "Wealing"
    Given I go to the logout page
    Given I log in as "joe"

  Scenario: Joe counts a gem in a conversation with Jane
    When I go to the dashboard page
    Then I should see "no intentions declared"
    When I follow "Declare"
    And I select "offer" from "play_intention_type"
    And I fill in "play_title" with "nice room"
    And I press "Record Play"
    Then I should be taken to the dashboard page
    Then I should see /Intentions:.*offer: nice room/

    
