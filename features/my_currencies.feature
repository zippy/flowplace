Feature: my currencies
  In order to coordinate and make visible the flows of working together
  As a player
  I want to be able to create currency accounts

  Background:
    Given I am logged into my account
    Given a "MutualCredit" currency "X"
    Given I am a member of currency "X"
    Given a "MutualCredit" currency "Y"
    Given I am a member of currency "Y"
    Given a "MutualCredit" currency "Z"

  Scenario: User looks at their currencies
    When I go to the my currencies page
    Then I should see "X"
    And I should see "Y"

  Scenario: User joins a currency
    When I go to the my currencies page
    Then I should not see "Z"
    When I follow "Join Currency"
    Then I should be taken to the join currency page
    When I select "Z" from "Currency"
    And I press "Join"
    Then I should be taken to the my currencies page
    And I should see "You have joined Z"

#  Scenario: User looks at a currency account
#    When I go to the currency accounts page
#    And I follow "X"
#    Then I should see "X" as the title of the page
#    And I should see "Currency Summary"
#
#  Scenario: User enters a trade
#    Given "Joe" is a member of currency "X"
#    When I go to the currency accounts page
#    And I follow "X"
#    And I fill in "amount" with "20"
#    And I fill in "description" with "leg waxing"
#    And I choose "Joe" from the "to" pop-up
#    And I click "place flow"
#    Then I should see my balance go down by "20"
