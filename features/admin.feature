Feature: Priviliged users
  In order to manage the system
  As a user with privs
  I want to be able to do more stuff

  Background:
    Given I am logged into my account
    Given I have "admin,accessAccounts" privs

  Scenario: Admin goes to the accounts page and lists all users
    When I go to the accounts page
    And I select "Show all" from "search_on_main"
    And I press "Search"
    Then I should be taken to the the accounts page
    And I should see "anonymous"
    And I should see "all 2"
  
  Scenario: Admin goes to the accounts page and searches for users by account name
    Given A user "user1"
    When I go to the accounts page
    And I select "Account name contains" from "search_on_main"
    And I fill in "search_for_main" with "user1"
    And I press "Search"
    And I should see "user1"
    And I should see "all 1"

  Scenario: Admin goes to the accounts page and searches for non existent user by account name
    When I go to the accounts page
    And I select "Account name contains" from "search_on_main"
    And I fill in "search_for_main" with "xxxy"
    And I press "Search"
    And I should see "No accounts foun"
