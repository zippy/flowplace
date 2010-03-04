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
    Given "jane" is a "member" of currency "We"
    Given I go to the logout page
    Given I log in as "joe"

  Scenario: Joe makes a trade with Jane and then another trade which passes the credit limit
    When I go to the dashboard page
    Then I should see /Balance:.*?0/
    And I should see /Limit:.*?100/
    When I select "Jane User's We member account" from "play_to"
    And I fill in "play_amount" with "100"
    And I fill in "play_memo" with "backrub"
    And I press "Record Play"
#    Then I should be taken to the dashboard page
    Then what
    And I should see /Balance:.*?-100/
    When I select "Jane User's We member account" from "play_to"
    And I fill in "play_amount" with "1"
    And I fill in "play_memo" with "one more dollar!"
    And I press "Record Play"
#    Then I should be taken to the dashboard page
    Then what
    And I should see /Balance:.*?-100/
    And I should see "Credit limit (100) exceeded."
    When I go to the logout page
    And I log in as "jane"
    And I go to the dashboard page
    Then I should see /Balance:.*?100/
