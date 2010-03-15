Feature: tgb currency
  In order to visualize our tgb state
  As a player
  I want to be able state my sense of goodness truth and beauty at a given momemnt

  Background:
    Given A user "joe"
    Given I am logged into my account
    Given a circle "the circle"
    Given I have "circle,currency" privs
    Given a "TrueGoodBeautiful" currency "TGB"
    And I bind "TGB" to "the circle"
    When I make "joe" a "member" of "the circle"
    Given "joe" is a "member" of currency "TGB"
    Given I go to the logout page
    Given I log in as "joe"

  Scenario: Users makes a play in a tgb currency
    When I go to the dashboard page
    And I select "1" from "play_truth"
    And I select "2" from "play_goodness"
    And I select "3" from "play_beauty"
    And I press "Record Play"
    Then I should be taken to the dashboard page
    And I should see "T:1"
    And I should see "G:2"
    And I should see "B:3"
