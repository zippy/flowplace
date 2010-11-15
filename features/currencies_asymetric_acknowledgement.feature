Feature: asymmetric acknowledgement currency
  In order to facilitate asymmetrical exchanges
  As a player
  I want to be able to record events where values don't need to match

  Background:
    Given I am logged into my account
    Given I have "circle,currency" privs
    Given a circle "the circle"
    When I go to the new "AsymmetricAcknowledgement" currencies page
    Then I should be taken to the new "AsymmetricAcknowledgement" currencies page
    When I fill in "Name" with "Prana"
    And I press "Create"
    Then I should be taken to the currencies page
    And I should see "Prana"
    And I bind "Prana" to "the circle"
    And A user "joe"
    And A user "jane"
    When I make "joe" a "member" of "the circle"
    When I make "jane" a "member" of "the circle"
    Given "joe" is a "member" of currency "Prana"
    Given "jane" is a "member" of currency "Prana"
    Given I go to the logout page
    Given I log in as "joe"

  Scenario: Joe records an event with Jane
    When I go to the dashboard page
    Then I should see "Inflow: 0"
    And I should see "Outflow: 0"
    When I follow "Initiate"
    And I select "Jane User's Prana member account" from "play_to"
    And I select "inflow" from "play_direction"
    And I fill in "play_amount" with "100"
    And I fill in "play_memo" with "backrub"
    And I press "Record Play"
    Then I should be taken to the dashboard page
    Then I should see "Inflow: 100"
    And I should see "Outflow: 0"
    When I follow "Initiate"
    And I select "Jane User's Prana member account" from "play_to"
    And I select "outflow" from "play_direction"
    And I fill in "play_amount" with "5"
    And I fill in "play_memo" with "smiles"
    And I press "Record Play"
    Then I should be taken to the dashboard page
    Then I should see "Inflow: 100"
    And I should see "Outflow: 5"
    When I go to the logout page
    And I log in as "jane"
    And I go to the dashboard page
    Then I should see "Inflow: 0"
    And I should see "Outflow: 0"
    And I should see /Pending:.*Joe User's Prana member account outflow of smiles at 5/
    And I should see /Pending:.*Joe User's Prana member account inflow of backrub at 100/
    When I follow "Complete"
    Then the field with id "play_play_id" should contain "Joe User's Prana member account"
# for these to work, it would require AJAX to fill the values on the fly as you select the accepted play
#    Then the field with id "play_memo" should contain "backrub"
#    Then the field with id "play_amount" should contain "100"
    And I select "Joe User's Prana member account outflow of smiles at 5" from "play_play_id"
    And I select "outflow" from "play_direction"
    And I fill in "play_amount" with "200"
    And I fill in "play_memo" with "back scratch"
    When I press "Record Play"
    Then I should be taken to the dashboard page
    Then I should see "Outflow: 200"
    And I should not see "Joe User's Prana member account outflow of smiles at 5"
    When I go to the holoptiview page
    Then I should see "Total plays: 2"
    Then I should see "Average plays/member: 1.0"
    Then I should see "Average Inflow: 50.0"
    Then I should see "Average Outflow: 102.5"
