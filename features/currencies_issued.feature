Feature: issued currency
  In order to play with issued currencies
  As a player
  I want to be able have fun!

  Background:
    Given I am logged into my account
    Given an "Issued" currency "WE"
    Given I am a "user" of currency "WE"
    Given "TT" is an "issuer" of currency "WE"
    Given "Joe" is a "user" of currency "WE"

  Scenario: Users makes a play in a tracked currency with no money
    When I go to the my currencies page
    And I follow "WE"
    Then I should be taken to the currency account play page for "Anonymous User's WE user account"
    And I should see "My Currencies: WE"
    And I should see "Balance: 0"
    When I select "Joe User's WE user account" from "play_to"
    And I fill in "play_amount" with "20"
    And I fill in "play[memo]" with "leg waxing"
    And I press "Record Play"
    And I should see "Insufficient Funds"
    And I should see "Balance: -20"
    When I follow "history"
    Then I should be taken to the currency account history page for "Anonymous User's WE user account"

  Scenario: Users makes a play in a tracked currency with money
    Given I go to the logout page
    Given I log in as "TT"
    When I go to the my currencies page
    And I follow "WE"
    When I select "Anonymous User's WE user account" from "play_to"
    And I fill in the "issue" form "play_amount" with "20"
    And I fill in the "issue" form "play[memo]" with "opening balance"
    And I press the "issue" form "Record Play"
    Then I should be taken to the my currencies page
    And I should see "Volume: 20"
    And I should see "In Circulation: 20"
    When I go to the logout page
    And I log in as "anonymous"
    And I go to the my currencies page
    And I follow "WE"
    And I select "Joe User's WE user account" from "play_to"
    And I fill in "play_amount" with "20"
    And I fill in "play[memo]" with "leg waxing"
    And I press "Record Play"
    And I should see "Balance: 20"
    
