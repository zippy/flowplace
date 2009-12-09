Feature: Navigation feedback
  In order that I don't get confused about where I am in the system
  As a user
  I want the current navigation tab to be displayed differently

  Background:
    Given I am logged into my account
    Given a circle "the circle"
    When I go to the players page for "the circle"
    When I select "Show all" from "search_on_main"
    And I press "Search"
    And I check "users_1"
    When I select "member" from "player_class"
    And I press "Submit"
    Given I have "admin" privs
    Given I have "accessAccounts" privs

  Scenario: User goes from one tab to the other
    When I go to the dashboard page
    Then I should see "Dashboard" as the current tab
    When I go to the holoptiview page
    Then I should see "Holoptiview" as the current tab
    When I go to the intentions page
    Then I should not see "Holoptiview" as the current tab
    And I should see "Intentions" as the current tab
    When I go to the actions page
    Then I should not see "Intentions" as the current tab
    And I should see "Actions" as the current tab
    When I go to the assets page
    Then I should not see "Actions" as the current tab
    And I should see "Assets" as the current tab
    When I go to the current circle members page
    Then I should see "Members" as the current tab
    And I should not see "Assets" as the current tab
    When I go to the currencies page
    And I should see "Currencies" as the current tab
    When I go to the circles page
    Then I should not see "Currencies" as the current tab
    And I should see "Circles" as the current tab
    When I go to the accounts page
    Then I should not see "Currencies" as the current tab
    And I should see "Accounts" as the current tab
    When I go to the admin page
    Then I should not see "Accounts" as the current tab
    And I should see "Admin" as the current tab
