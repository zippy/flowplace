Feature: dashboard
  In order to coordinate and make visible the flows of working together
  As a player
  I want to be able coordinate all my action from one place

  Background:
    Given a "MutualCredit" currency "X"
    Given "joe" is a "member" of currency "X"
    Given "jane" is a "member" of currency "X"
    Given a "MutualCredit" currency "Y"
    Given "joe" is a "member" of currency "Y"
    Given "herbert" is a "member" of currency "Y"
    Given a "MutualCredit" currency "Z"
    Given I am logged into my "matrice" account
    And a circle "this circle" with members "joe,jane,jacob"
    And I bind "X" to "this circle"
    And a circle "that circle" with members "joe,herbert,jacob"
    And I bind "Y" to "that circle"
    Given I go to the logout page

  Scenario: User looks at their dashboard and sees the currencies in their circle
    When I log in as "joe"
    Then I should be taken to the dashboard page
    And I should see "Dashboard" as the current tab
    And I should see a "X" "member" dashboard item
    And I should not see a "Y" "member" dashboard item
    And I should not see a "Z" "member" dashboard item

  Scenario: Matrices looks at a circle's dashboard and sees the circle's membrane currency
    When I log in as "matrice"
    Then I should be taken to the dashboard page
    And I should see "Dashboard" as the current tab
    And I should see a "this circle" "matrice" dashboard item
    And I should not see a "that circle" "matrice" dashboard item
    And I should not see a "X" "member" dashboard item
    And I should not see a "Y" "member" dashboard item
    And I should not see a "Z" "member" dashboard item
    When I go to the dashboard page for "that circle"
    Then I should see a "that circle" "matrice" dashboard item
    And I should not see a "this circle" "matrice" dashboard item
    And I should not see a "X" "member" dashboard item
    And I should not see a "Y" "member" dashboard item
    And I should not see a "Z" "member" dashboard item

  Scenario: User makes a play in a currency
    When I log in as "joe"
    And I go to the "pay" play page for my "member" account in "X"
    And I should see "X: Pay"
    And I should see "Balance: 0"
    When I select "Jane User's X member account" from "play_to"
    And I fill in "play_amount" with "20"
    And I fill in "play[memo]" with "leg waxing"
    And I press "Record Play"
#    Then I should be taken to the my currencies page
    And I should see "-20"
    When I follow "history"
    Then I should be taken to the currency account history page for "Anonymous User's X member account"
    And I should see "leg waxing"
    
#  Scenario: User looks at a currency account
#    When I go to the currency accounts page
#    And I follow "X"
#    Then I should see "X" as the title of the page
#    And I should see "Currency Summary"
