Feature: Intentions
  In order that my intentions can build wealth in the community
  As a player
  I want to be able to declare and manage my intentions in the system

  Background:
    Given a "MutualCredit" currency "X"
    And a "MutualCredit" currency "Y"
    Given I am logged into my "matrice" account
    And a circle "the circle" with members "joe,jane,jacob"
    And I bind "X" to "the circle"
    And I grant "joe" role "member" in "X" for "the circle"
    And I go to the logout page
    Given I am logged into my "joe" account

  Scenario: Declaring an intention
    When I go to the new intentions page
    Then I should see "X" within "#intention_currency_list"
    And I should not see "Y" within "#intention_currency_list"
    When I fill in "Title" with "intention 1"
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
  