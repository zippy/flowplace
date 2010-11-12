Feature: mutual acknowledgement currency
  In order to facilitate asymmetrical exchanges
  As a player
  I want to be able to record exchanges using mutual acknowledgement

  Background:
    Given I am logged into my account
    Given I have "circle,currency" privs
    Given a circle "the circle"
    When I go to the new "MutualAcknowledgement" currencies page
    Then I should be taken to the new "MutualAcknowledgement" currencies page
    When I fill in "Name" with "WE"
    And I press "Create"
    Then I should be taken to the currencies page
    And I should see "WE"
    And I bind "WE" to "the circle"
    And A user "joe"
    And A user "jane"
    When I make "joe" a "member" of "the circle"
    When I make "jane" a "member" of "the circle"
    Given "joe" is a "member" of currency "WE"
    Given "jane" is a "member" of currency "WE"
    Given I go to the logout page
    Given I log in as "joe"

  Scenario: Joe makes a trade with Jane
    When I go to the dashboard page
    Then I should see /Balance: 0/
    When I follow "Acknowledge"
    And I select "Jane User's WE member account" from "play_to"
    And I fill in "play_amount" with "100"
    And I fill in "play_memo" with "backrub"
    And I press "Record Play"
    Then I should be taken to the dashboard page
    And I should see /Balance: -100/
    When I follow "Acknowledge"
    And I select "Jane User's WE member account" from "play_to"
    And I fill in "play_amount" with "5"
    And I fill in "play_memo" with "smiles"
    And I press "Record Play"
    Then I should be taken to the dashboard page
    And I should see /Balance: -105/
    When I go to the logout page
    And I log in as "jane"
    And I go to the dashboard page
    Then I should see /Balance: 0/
    And I should see /Pending:.*Joe User's WE member account acknowledgement of smiles at 5/
    And I should see /Pending:.*Joe User's WE member account acknowledgement of backrub at 100/
    When I follow "Accept"
    Then the field with id "play_play_id" should contain "Joe User's WE member account"
# for these to work, it would require AJAX to fill the values on the fly as you select the accepted play
#    Then the field with id "play_memo" should contain "backrub"
#    Then the field with id "play_amount" should contain "100"
    And I fill in "play_amount" with "200"
    And I fill in "play_memo" with "back scratch"
    When I press "Record Play"
    Then I should be taken to the dashboard page
    And I should see /Balance: 200/
