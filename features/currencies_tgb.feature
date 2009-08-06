Feature: tgb currency
  In order to visualize our tgb state
  As a player
  I want to be able state my sense of goodness truth and beauty at a given momemnt

  Background:
    Given I am logged into my account
    Given a "TrueGoodBeautiful" currency "TGB"
    Given I am a "member" of currency "TGB"

  Scenario: Users makes a play in a tgb currency
    When I go to the my currencies page
    And I follow "TGB"
    Then I should be taken to the currency account play page for "Anonymous User's TGB member account"
    And I should see "My Currencies TGB"
    And I should see "T: G: B:"
    And I select "1" from "play_truth"
    And I select "2" from "play_goodness"
    And I select "3" from "play_beauty"
    And I press "Record Play"
    Then I should be taken to the my currencies page
    And I should see "T:1"
    And I should see "G:2"
    And I should see "B:3"
