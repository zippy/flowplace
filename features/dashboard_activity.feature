Feature: dashboard activity tab
  In order to keep current
  As a player
  I want to be able see activity in all currencies in one place

  Background:
    Given a "MutualCredit" currency "X"
    Given "joe" is a "member" of currency "X"
    Given "jane" is a "member" of currency "X"
    Given a "MutualCredit" currency "Y"
    Given "joe" is a "member" of currency "Y"
    Given "herbert" is a "member" of currency "Y"
    Given a "MutualCredit" currency "Z"
    Given I am logged into my "namer" account
    And I have "circle" privs
    And a circle "this circle" with members "joe,jane,jacob"
    And I bind "X" to "this circle"
    And a circle "that circle" with members "joe,herbert,jacob"
    And I bind "Y" to "that circle"
    Given I go to the logout page

  Scenario: User looks at their activity dashboard and sees recent activity
    When I log in as "joe"
    And I go to the dashboard activity page
    And I should see "Dashboard" as the current tab
    And I should see "Activity" as the active sub-tab
    And I should see "Currencies" as a sub-tab

  Scenario: User makes a play in a currency
    When I log in as "joe"
    And I go to the "pay" play page for my "member" account in "X"
    And I should see "X: Pay"
    And I should see "Balance: 0"
    When I select "Jane User's X member account" from "play_to"
    And I fill in "play_amount" with "20"
    And I fill in "play[memo]" with "leg waxing"
    And I press "Record Play"
    And I go to the dashboard activity page for "this circle"
    Then I should see "Joe User's X member account pays Jane User's X member account 20 for leg waxing" within "#activity"
    When I go to the dashboard activity page for "that circle"
    Then I should see no activity items