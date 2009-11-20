Feature: membrane currency
  In order to create boundaries between integral systems
  As a player
  I want to be able to be in the flow of naming & binding

  Background:
    Given I am logged into my account
    And a circle "the circle"

  Scenario: Matrice views the currency playpage
    When I go to the my currencies page
    And I follow "the circle"
    Then I should be taken to the currency account play page for "anonymous"
    And I should see "the circle: grant"
    And I should see "Grant" as the active play
    And I should see "Revoke" as a possible play

  Scenario: Matrice makes a bind currency play
    When I go to the my currencies page
    And I follow "the circle"
    When I select "Joe User's WE user account" from "play_to"
    And I fill in "play_amount" with "20"
    And I fill in "play[memo]" with "leg waxing"
    And I press "Record Play"
    
