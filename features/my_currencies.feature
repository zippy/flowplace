Feature: my currencies
  In order to coordinate and make visible the flows of working together
  As a player
  I want to be able to see a list of all my currency accounts

  Background:
    Given I am logged into my account
    Given a "MutualCredit" currency "X"
    Given I am a "member" of currency "X"
    Given a "MutualCredit" currency "Y"
    Given I am a "member" of currency "Y"
    Given a "MutualCredit" currency "Z"

  Scenario: User looks at their currencies
    When I go to the my currencies page
    Then I should see a currency account "Anonymous User's X member account"
    And I should see a currency account "Anonymous User's Y member account"
