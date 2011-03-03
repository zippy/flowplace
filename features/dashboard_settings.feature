Feature: dashboard currency account settings tab
  In order to customize how my account in a currency behaves
  As a player
  I want to be able access the account settings from the dashboard

  Background:
    Given a "MutualCredit" currency "X"
    Given "joe" is a "member" of currency "X"
    Given "jane" is a "member" of currency "X"
    Given I am logged into my "namer" account
    And I have "circle" privs
    And a circle "this circle" with members "joe,jane"
    And I bind "X" to "this circle"
    Given I go to the logout page

  Scenario: User navigates to a currency account's settings
    When I log in as "joe"
    And I go to the dashboard page
    And I follow "X" within "#dashboard_x_member"
    Then I should be taken to the settings page for my "member" account in "X"
    And I should see "Settings" as the active sub-tab

  Scenario: User changes a currency account notification settings
    When I log in as "joe"
    Then I go to the settings page for my "member" account in "X"
    Then "" should be selected for "Notification"
    When I select "email" from "Notification"
    And I press "Update"
    Then I should see "The currency settings were updated."
    And I should be taken to the settings page for my "member" account in "X"
    And "email" should be selected for "Notification"
    When I go to the logout page
    And I log in as "jane"
    When I go to the dashboard page
    When I follow "Pay"
    And I select "Joe User's X member account" from "play_to"
    And I fill in "play_amount" with "100"
    And I fill in "play_memo" with "backrub"
    And I press "Record Play"
    Then The last email delivered is from "eric@harris-braun.com" and to "joe@harris-braun.com"
    And The last email delivered contains "Jane User's X member account pays Joe User's X member account 100 for backrub"
    And The last email delivered contains "A play involving you was made in X by Jane User (Jane User's X member account):"
