Feature: Intentions
  In order that my intentions can build wealth in the community
  As a player
  I want to be able to declare and manage my intentions in the system

  Background:
    Given a "MutualCredit" currency "X"
    And a "MutualCredit" currency "Y"
    Given I am logged into my "matrice" account
    And a circle "this circle" with members "joe,jane,jacob"
    And a circle "that circle" with members "joe,herbert,jacob"
    And I bind "X" to "this circle"
    And I bind "Y" to "that circle"
    And I grant "joe" role "member" in "X" for "this circle"
    And I grant "joe" role "member" in "Y" for "this circle"
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

  Scenario: Declaring intentions in different circles
    When I go to the dashboard page for "this circle"
    And I declare "intention 1" described as "desc1" measuring wealth with "X"
    And I go to the dashboard page for "that circle"
    And I declare "intention 2" described as "desc2" measuring wealth with "Y"
    And I go to the dashboard page for "this circle"
    And I go to the intentions page
    Then I should see "intention 1"
    And I should not see "intention 2"
    And I go to the my intentions page
    Then I should see "intention 1"
    And I should not see "intention 2"
    And I go to the dashboard page for "that circle"
    And I go to the intentions page
    Then I should see "intention 2"
    And I should not see "intention 1"
    And I go to the my intentions page
    Then I should see "intention 2"
    And I should not see "intention 1"

  Scenario: Removing a currency from an intention
    Given I declare "intention 1" described as "desc" measuring wealth with "X"
    When I go to the edit intentions page for "intention 1"
    And I uncheck "currencies_1_used"
    And I press "Update"
    Then I should be taken to the my intentions page
    And I should not see an image with title "X: "
  