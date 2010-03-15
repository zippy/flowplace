Feature: mutual rating currency
  In order to encourage attainment of higher levels
  As a player
  I want to be able rate other players and be rated by them

  Background:
    Given I am logged into my account
    Given I have "circle,currency" privs
    When I go to the new "Mutual Rating" currencies page
    Then I should be taken to the new "Mutual Rating" currencies page
    Then I should see "Name"
    And I fill in "Name" with "Catalysts"
    And I fill in "config_rate.rating" with "Networker,Connector,Weaver,Catalyst"
    And I press "Create"
    Then I should be taken to the currencies page
    And I should see "Catalysts"
    Given I am a "member" of currency "Catalysts"
    Given "Joe" is a "member" of currency "Catalysts"
    Given "Jane" is a "member" of currency "Catalysts"

  Scenario: Users makes a play in a mutual rating currency
    When I go to the my currencies page
    And I follow "Catalysts"
    Then I should be taken to the currency account play page for "Anonymous User's Catalysts member account"
    When I select "Joe User's Catalysts member account" from "play_to"
    And I select "Networker" from "play_rating"
    And I press "Record Play"
    Given I go to the logout page
    Given I log in as "Jane"
    When I go to the my currencies page
    And I follow "Catalysts"
    When I select "Joe User's Catalysts member account" from "play_to"
    And I select "Weaver" from "play_rating"
    And I press "Record Play"
    Given I go to the logout page
    And I log in as "Joe"
    When I go to the my currencies page
    And I should see "Connector"
