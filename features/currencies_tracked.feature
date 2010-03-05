Feature: tracked currency
  In order to track flows of dollars
  As a player
  I want to be able to tracking federal currencies

  Background:
    Given I am logged into my account
    Given I have "admin" privs
    Given a circle "the circle"
    Given a "Tracked" currency "USD"
    And I bind "USD" to "the circle"
    Given I am a "member" of currency "USD"
    When I make "anonymous" a "member" of "the circle"

  Scenario: Users makes a play in a tracked currency
    Given "Joe" is a "member" of currency "USD"
    When I go to the my currencies page
    And I follow "USD"
    Then I should be taken to the currency account play page for "Anonymous User's USD member account"
    And I should see "My Currencies USD: transfer"
    And I should see "Balance: 0"
    When I select "Joe User's USD member account" from "play_to"
    And I fill in "play_amount" with "20"
    And I fill in "play[memo]" with "leg waxing"
    And I press "Record Play"
    Then I should be taken to the dashboard page
    And I should see /Balance:.*-20/
    When I follow "history"
    Then I should be taken to the currency account history page for "Anonymous User's USD member account"
