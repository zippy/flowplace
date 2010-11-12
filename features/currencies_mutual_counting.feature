Feature: mutual counting currency
  In order to facilitate awareness of progress
  As a player
  I want to be able to count participation in events

  Background:
    Given I am logged into my account
    Given I have "circle,currency" privs
    Given a circle "the circle"
    When I go to the new "MutualCounting" currencies page
    Then I should be taken to the new "MutualCounting" currencies page
    When I fill in "Name" with "Counter"
    And I press "Create"
    Then I should be taken to the currencies page
    And I should see "Counter"
    And I bind "Counter" to "the circle"
    And A user "joe"
    And A user "jane"
    When I make "joe" a "member" of "the circle"
    When I make "jane" a "member" of "the circle"
    When I make "jacob" a "member" of "the circle"
    Given "jane" is a "member" of currency "Counter"
    Given "jacob" is a "member" of currency "Counter"
    Given "joe" is a "creator" of currency "Counter"
    Given I go to the logout page
    Given I log in as "joe"

  Scenario: Joe counts a gem in a conversation with Jane
    When I go to the dashboard page
    Then I should see /Counts:.*no countables defined/
    When I follow "Create Countable"
    And I fill in "play_name" with "Conversation Gems"
    And I fill in "play_description" with "we are tracking gems that come out of conversations"
    And I press "Record Play"
    Then I should be taken to the dashboard page
    And I should see /Counts:.*Conversation Gems: 0/
    When I follow "Count"
    And I select "Conversation Gems" from "play_countable"
    And I select "Jane User's Counter member account" from "play_to"
    And I fill in "play_memo" with "gem was: X"
    And I press "Record Play"
    Then I should be taken to the dashboard page
    And I should see /Counts:.*Conversation Gems: 1/
    When I go to the logout page
    And I log in as "jane"
    And I go to the dashboard page
    Then I should see /Counts:.*Conversation Gems: 1/
    When I follow "Count"
    And I select "Conversation Gems" from "play_countable"
    And I select "Joe User's Counter creator account" from "play_to"
    And I fill in "play_memo" with "gem was: Y"
    And I press "Record Play"
    Then I should be taken to the dashboard page
    And I should see /Counts:.*Conversation Gems: 2/
    When I go to the logout page
    And I log in as "joe"
    Then I should see /Counts:.*Conversation Gems: 2/
    When I follow "Reset Counts"
    And I select "Conversation Gems" from "play_countable"
    And I press "Record Play"
    Then I should be taken to the dashboard page
    And I should see /Counts:.*Conversation Gems: 0/
    
