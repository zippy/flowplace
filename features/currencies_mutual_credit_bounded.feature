Feature: bounded mutual credit currency
  In order to facilitate exchanges with boundaries
  As a player
  I want to be able to record exchanges of using mutual credit but know that we are playing within limits

  Background:
    Given I am logged into my account
    Given I have "admin" privs
    Given a circle "the circle"
    When I go to the new "MutualCreditBounded" currencies page
    Then I should be taken to the new "MutualCreditBounded" currencies page
    When I fill in "Name" with "We"
    And I fill in "config__.min_negative_balance" with "100"
    And I fill in "config__.max_negative_balance" with "1000"
    And I press "Create"
    Then I should be taken to the currencies page
    And I should see "We"
    And I bind "We" to "the circle"
    And A user "joe"
    And A user "jane"
    When I make "joe" a "member" of "the circle"
    When I make "jane" a "member" of "the circle"
    Given "joe" is a "member" of currency "We"
    And "joe" is an "admin" of currency "We"
    Given "jane" is a "member" of currency "We"
    Given I go to the logout page
    Given I log in as "joe"

  Scenario: Joe makes a trade with Jane and then another trade which passes the credit limit
    When I go to the dashboard page
    Then I should see /Balance:.*?0/
    And I should see /Limit:.*?100/
    When I select "Jane User's We member account" from "play_to" within "#dashboard_we_member"
    And I fill in "play_amount" with "100"
    And I fill in "play_memo" with "backrub"
    And I press "Record Play"
#    Then I should be taken to the dashboard page
    And I should see /Balance:.*?-100/
    When I select "Jane User's We member account" from "play_to" within "#dashboard_we_member"
    And I fill in "play_amount" with "1"
    And I fill in "play_memo" with "one more dollar!"
    And I press "Record Play"
#    Then I should be taken to the dashboard page
    And I should see /Balance:.*?-100/
    And I should see "Credit limit (100) exceeded."
    When I go to the logout page
    And I log in as "jane"
    And I go to the dashboard page
    Then I should see /Balance:.*?100/

  Scenario: Joe views his transaction history before and after a transaction
    When I go to the dashboard page
    When I follow "History" within "#dashboard_we_member"
    Then I should see "You have made no plays in this currency as a member."
    When I go to the dashboard page
    And I select "Jane User's We member account" from "play_to" within "#dashboard_we_member"
    And I fill in "play_amount" with "100"
    And I fill in "play_memo" with "backrub"
    And I press "Record Play"
    And I follow "History" within "#dashboard_we_member"
    Then I should see a table with 2 rows
    Then I should see "Joe User's We member account" in row 1 column 0
    Then I should see "Jane User's We member account" in row 1 column 1
    Then I should see "100" in row 1 column 2
    Then I should see "backrub" in row 1 column 3

  Scenario: Joe sets a credit limit
    When I go to the dashboard page
    Then I should see /Limit:.*?100/
    When I select "Joe User's We member account" from "play_to" within "#dashboard_we_admin"
    And I fill in "play_limit" with "500"
    And I press "Record Play" within "#dashboard_we_admin"
    Then I should see /Limit:.*?500/

  Scenario: Joe tries to set a credit limit above system max
    When I go to the dashboard page
    When I select "Joe User's We member account" from "play_to" within "#dashboard_we_admin"
    And I fill in "play_limit" with "5000"
    And I press "Record Play" within "#dashboard_we_admin"
    And I should see "Limit must be less than system maximum: 1000"
    
  Scenario: Joe tries to set a credit limit below system min
    When I go to the dashboard page
    When I select "Joe User's We member account" from "play_to" within "#dashboard_we_admin"
    And I fill in "play_limit" with "5"
    And I press "Record Play" within "#dashboard_we_admin"
    And I should see "Limit must be greater than system minimum: 100"
