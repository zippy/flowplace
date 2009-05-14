Feature: Navigation feedback
  In order that I don't get confused about where I am in the system
  As a user
  I want the current navigation tab to be displayed differently

  Background:
    Given I am logged into my account
    Given I have "admin" privs
    Given I have "accessAccounts" privs

  Scenario: User goes from one tab to the other
    When I go to the my wealth stream page
    Then I should see "My Wealth Stream" as the current tab
    When I go to the intentions page
    Then I should not see "My Wealth Stream" as the current tab
    And I should see "Intentions" as the current tab
    When I go to the my currencies page
    Then I should not see "Intentions" as the current tab
    And I should see "My Currencies" as the current tab
    When I go to the circles page
    Then I should not see "My Currencies" as the current tab
    And I should see "Circles" as the current tab
    When I go to the currencies page
    Then I should not see "Circles" as the current tab
    And I should see "Currencies" as the current tab
    When I go to the match page
    Then I should not see "Currencies" as the current tab
    And I should see "Match" as the current tab
    When I go to the accounts page
    Then I should not see "Match" as the current tab
    And I should see "Accounts" as the current tab
    When I go to the admin page
    Then I should not see "Accounts" as the current tab
    And I should see "Admin" as the current tab
