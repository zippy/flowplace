Feature: Proposals
  In order that requesting and offering intentions can be matched
  As a player
  I want to be able to make proposals to intentions

  Background:
    Given a "MutualCredit" currency "X"
    And I am logged into my "intender" account
    And an intention "intention 1" described as "desc" measuring wealth with "X"
    And I go to the logout page
    Given I am logged into my account

  Scenario: Making a proposal
    When I go to the all intentions page
    And I follow "intention 1"
    Then I should be taken to the view intentions page for "intention 1"
    When I fill in "proposal_description" with "Here's my proposal..."
    And I press "Submit Proposal"
    Then I should be taken to the all intentions page
    And I should see "(1 proposal)"

  Scenario: Making a proposal without a description
    When I go to the view intentions page for "intention 1"
    And I press "Submit Proposal"
    Then I should be taken to the view intentions page for "intention 1"
    And I should see "Please enter the text of your proposal"

  Scenario: Updating a proposal
    When I go to the view intentions page for "intention 1"
    And I fill in "proposal_description" with "Here's my proposal..."
    And I press "Submit Proposal"
    Then I should be taken to the all intentions page
    And I should see "(1 proposal)"
    When I go to the view intentions page for "intention 1"
    And I fill in "proposal_description" with "Here's my changed proposal..."
    And I press "Update Proposal"
    Then I should be taken to the all intentions page
    And I should see "(1 proposal)"
    When I go to the view intentions page for "intention 1"
    Then I should see "Here's my changed proposal..."

  Scenario: Withdrawing a proposal
    When I go to the view intentions page for "intention 1"
    And I fill in "proposal_description" with "Here's my proposal..."
    And I press "Submit Proposal"
    Then I should be taken to the all intentions page
    And I should see "(1 proposal)"
    When I go to the view intentions page for "intention 1"
    And I press "Withdraw Proposal"
    Then I should be taken to the all intentions page
    And I should not see "(1 proposal)"
    And I should see "Proposal was withdrawn."
