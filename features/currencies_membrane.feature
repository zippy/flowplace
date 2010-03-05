Feature: membrane currency
  In order to create boundaries between integral systems
  As a player
  I want to be able to be in the flow of naming & binding

  Background:
    Given I am logged into my account
    And a circle "the circle"

  Scenario: Namer views the currency play page
    When I go to the my currencies page
    And I follow "the circle" within "#currency_account_anonymous"
    Then I should be taken to the currency account play page for "anonymous"
    And I should see "Name Member" as the active play
    And I should see "Grant" as a possible play
    And I should see "Revoke" as a possible play
    And I should see "Bind Currency" as a possible play

  Scenario: Namer makes a bind currency play
    Given a "MutualCredit" currency "MC"
    When I go to the "bind_currency" play page for my "namer" account in "the circle"
    And I select "MC" from "play[currency]"
    And I fill in "play_name" with "MC" 
    And I press "Record Play"
    When I go to the currencies page for "the circle"
    Then I should see a table with 2 rows within "#circle_currencies"
    And I should see "MC" in row 1 column 0
    
