Feature: membrane currency
  In order to create boundaries between integral systems
  As a player
  I want to be able to be in the flow of naming & binding

  Background:
    Given I am logged into my account
    Given I have "circle" privs
    And a circle "the circle"
    And I follow "Preferences"
    And I check "prefs[showMembranes]"
    And I press "Set Preferences"

#TODO: This is bogus because the my currencies page was never fully implemented, and it lists multiple currency accounts
# with the same #currency_account_anonymous.  It only works because the first one is the namer currency account.
  Scenario: Namer views the currency play page
    When I go to the my currencies page
    And I follow "the circle" within "#currency_account_anonymous"
    Then I should be taken to the currency account play page for "anonymous"
    And I should see "Bind Currency" as the active play
    And I should see "Unbind Currency" as a possible play
    And I should see "Name Member" as a possible play
    And I should see "Grant" as a possible play
    And I should see "Revoke" as a possible play

  Scenario: Namer makes a bind currency play
    Given a "MutualCredit" currency "MC"
    When I go to the "bind_currency" play page for my "namer" account in "the circle"
    And I select "MC" from "play[currency]"
    And I fill in "play_name" with "MC" 
    And I press "Record Play"
    When I go to the currencies page for "the circle"
    Then I should see a table with 2 rows within "#circle_currencies"
    And I should see "MC" in row 1 column 0
    
  Scenario: Namer makes a bind currency play with autojoin
    Given a "MutualCredit" currency "MC"
    When I go to the "bind_currency" play page for my "namer" account in "the circle"
    And I select "MC" from "play[currency]"
    And I fill in "play_name" with "MC" 
    And I select "true" from "play_autojoin"
    And I press "Record Play"
    When I go to the currencies page for "the circle"
    Then I should see a table with 2 rows within "#circle_currencies"
    And I should see "MC (autojoin)" in row 1 column 0