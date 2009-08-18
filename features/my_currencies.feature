Feature: my currencies
  In order to coordinate and make visible the flows of working together
  As a player
  I want to be able to create currency accounts

  Background:
    Given I am logged into my account
    Given a "MutualCredit" currency "X"
    Given I am a "member" of currency "X"
    Given a "MutualCredit" currency "Y"
    Given I am a "member" of currency "Y"
    Given a "MutualCredit" currency "Z"

  Scenario: User looks at their currencies
    When I go to the my currencies page
    Then I should see a currency account "Anonymous User's X member account"
    And I should see a currency account "Anonymous User's Y member account"

  Scenario: User joins a currency
    When I go to the my currencies page
    Then I should not see a currency account "Anonymous User's Z member account"
    When I follow "Join"
    Then I should be taken to the join currency page
    When I press "Join"
    And I should see "There were problems with the following fields"
    Then I should be taken to the join currency page
    When I select "Z: " from "Currency"
    When I fill in "Player Class" with "member"
    And I press "Join"
    Then I should be taken to the my currencies page
    And I should see "You have joined Z"
    And I should see a currency account "anonymous"
    When I follow "Join"
    Then I should not see "Z: "
    And I should see "There are no currencies you can join"

  Scenario: User joins a currency with multi wallet pref checked
    When I go to the join currency page
    Then I should not see "Wallet:"
    Given I have checked the "multi_wallet" preference
    When I go to the my currencies page
    Then I should not see a currency account "Anonymous User's Z member account"
    When I follow "Join"
    Then I should be taken to the join currency page
    Then I should see "Wallet:"
    When I select "Z: " from "Currency"
    When I fill in "Player Class" with "member"
    And I fill in "Account Name" with "my_account"
    And I press "Join"
    Then I should be taken to the my currencies page
    And I should see "You have joined Z"
    And I should see a currency account "anonymous.my_account"
    When I follow "Join"
    Then I should see "Z: "
    And I should not see "There are no currencies you can join"
    
  Scenario: User leaves a currency
    When I go to the my currencies page
    And I follow "Leave currency" for currency account "Anonymous User's X member account"
    Then I should be taken to the my currencies page
    And I should not see a currency account "Anonymous User's X member account"
    And I should see "You have left X"

  Scenario: Users makes a play in a currency
    Given "Joe" is a "member" of currency "X"
    When I go to the my currencies page
    And I follow "X"
    Then I should be taken to the currency account play page for "Anonymous User's X member account"
    And I should see "Enter a play in: X"
    And I should see "Balance: 0"
    When I select "Joe User's X member account" from "play_to"
    And I fill in "play_amount" with "20"
    And I fill in "play[memo]" with "leg waxing"
    And I press "Record Play"
    Then I should be taken to the my currencies page
    And I should see "-20"
    When I follow "history"
    Then I should be taken to the currency account history page for "Anonymous User's X member account"
    And I should see "leg waxing"
    
#  Scenario: User looks at a currency account
#    When I go to the currency accounts page
#    And I follow "X"
#    Then I should see "X" as the title of the page
#    And I should see "Currency Summary"
