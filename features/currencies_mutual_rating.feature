Feature: mutual rating currency
  In order to encourage attainment of higher levels
  As a player
  I want to be able rate other players and be rated by them

  Background:
    Given I am logged into my account
    Given a "MutualRating" currency "Catalysts"
    Given I am a "member" of currency "Catalysts"
    Given "Joe" is a "member" of currency "Catalysts"
    Given "Jane" is a "member" of currency "Catalysts"

  Scenario: Users makes a play in a mutual rating currency
    When I go to the my currencies page
    And I follow "Catalysts"
    Then I should be taken to the currency account play page for "Anonymous User's Catalysts member account"
    When I select "Joe User's Catalysts member account" from "play_to"
    And I select "1" from "play_rating"
    And I press "Record Play"
    Given I go to the logout page
    Given I log in as "Jane"
    When I go to the my currencies page
    And I follow "Catalysts"
    When I select "Joe User's Catalysts member account" from "play_to"
    And I select "3" from "play_rating"
    And I press "Record Play"
    Given I go to the logout page
    And I log in as "Joe"
    When I go to the my currencies page
    And I should see "My Rating: 2"
