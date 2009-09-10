Feature: Intentions
  In order that my intentions can build wealth in the community
  As a player
  I want to be able to declare and manage my intentions in the system

  Background:
    Given I am logged into my account
    Given a "MutualCredit" currency "X"

  Scenario: Declaring an intention
    When I go to the new intentions page
    And I fill in "Title" with "intention 1"
    And I fill in "Description" with "intention 1 description"
    And I check "currencies_1_used"
    And I press "Declare"
    Then I should be taken to the my intentions page
    And I should see "intention 1"
    And I should see an image with title "X: "

  Scenario: Removing a currency from an intention
    Given an intention "intention 1" described as "desc" measuring wealth with "X"
    When I go to the edit intentions page for "intention 1"
    And I uncheck "currencies_1_used"
    And I press "Update"
    Then I should be taken to the my intentions page
    And I should not see an image with title "X: "
  