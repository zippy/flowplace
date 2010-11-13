Feature: dashboard currency account settings tab
  In order to keep modify account settings
  As a player
  I want to be able see and change all my per-account settings in one place

  Background:
    Given a "MutualCredit" currency "X"
    Given "joe" is a "member" of currency "X"
    Given I am logged into my "namer" account
    And I have "circle" privs
    And a circle "this circle" with members "joe"
    And I bind "X" to "this circle"
    Given I go to the logout page

  Scenario: User navigates to a currency account's settings
    When I log in as "joe"
    And I go to the dashboard page
    And I follow "X" within "#dashboard_x_member"
    Then I should be taken to the settings page for my "member" account in "X"
    And I should see "Settings" as the active sub-tab

  Scenario: User navigates to a currency account's settings
    When I log in as "joe"
    Then I go to the settings page for my "member" account in "X"
    And I should see "Settings" as the active sub-tab
