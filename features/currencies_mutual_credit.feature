Feature: mutual credit currency
  In order to facilitate exchanges
  As a player
  I want to be able to record exchanges of using mutual credit

  Background:
    Given I am logged into my account
    Given I have "circle,currency" privs
    Given a circle "the circle"
    When I go to the new "MutualCredit" currencies page
    Then I should be taken to the new "MutualCredit" currencies page
    When I fill in "Name" with "LETS"
    And I press "Create"
    Then I should be taken to the currencies page
    And I should see "LETS"
    And I bind "LETS" to "the circle"
    And A user "joe"
    And A user "jane"
    When I make "joe" a "member" of "the circle"
    When I make "jane" a "member" of "the circle"
    Given "joe" is a "member" of currency "LETS"
    Given "jane" is a "member" of currency "LETS"
    Given I go to the logout page
    Given I log in as "joe"

  Scenario: Joe makes a trade with Jane
    When I go to the dashboard page
    Then I should see "Balance: 0"
    When I follow "Pay"
    And I select "Jane User's LETS member account" from "play_to"
    And I fill in "play_amount" with "100"
    And I fill in "play_memo" with "backrub"
    And I press "Record Play"
    Then I should be taken to the dashboard page
    And I should see "Balance: -100"
    And I should see "Volume: 100"
    And I should see "Transactions: 1"
    When I go to the logout page
    And I log in as "jane"
    And I go to the dashboard page
    Then I should see "Balance: 100"
    And I should see "Volume: 100"
    And I should see "Transactions: 1"
    When I go to the holoptiview page
    Then I should see "Total transactions: 1"
    Then I should see "Average transactions/member: 0.5"
