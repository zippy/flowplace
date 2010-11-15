Feature: thanks currency
  In order to feel the sense of gratitude in the community
  As a player
  I want to be able send and receive thanks

  Background:
    Given I am logged into my account
    Given I have "circle,currency" privs
    Given a circle "the circle"
    When I go to the new "Thanks" currencies page
    Then I should be taken to the new "Thanks" currencies page
    When I fill in "Name" with "Greatfulness"
    And I press "Create"
    Then I should be taken to the currencies page
    And I should see "Greatfulness"
    And I bind "Greatfulness" to "the circle"
    And A user "joe"
    And A user "jane"
    When I make "joe" a "member" of "the circle"
    When I make "jane" a "member" of "the circle"
    Given "joe" is a "member" of currency "Greatfulness"
    Given "jane" is a "member" of currency "Greatfulness"
    Given I go to the logout page
    Given I log in as "joe"

  Scenario: Joe thanks Jane
    When I go to the dashboard page
    And I follow "Thank"
    When I select "Jane User's Greatfulness member account" from "play_to"
    And I fill in "play_memo" with "the great things you did"
    And I press "Record Play"
    Then I should be taken to the dashboard page
    And I should see "Thanks given: 1" within "#dashboard_greatfulness_member"
    And I should see "Thanks received: 0" within "#dashboard_greatfulness_member"
    And I should see /Recent:.*given to Jane.*?User's.*?Greatfulness.*?member.*?account/ within "#dashboard_greatfulness_member"
    When I go to the logout page
    And I log in as "jane"
    And I go to the dashboard page
    And I should see "Thanks given: 0" within "#dashboard_greatfulness_member"
    And I should see "Thanks received: 1" within "#dashboard_greatfulness_member"
    And I should see /Recent:.*received from Joe.*?User's.*?Greatfulness.*?member.*?account/ within "#dashboard_greatfulness_member"

    
