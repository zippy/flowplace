Feature: flowplace dashboard
  In order to take action at the flowplace level
  As a user
  I want to see all my options at one place
  
  Scenario: a user without circles goes to the dashboard and sees the welcome item for exploring circles
    When I am logged into my "new" account
    And I go to the dashboard page
    Then I should see a "Welcome" dashboard item
    And I should see "Dashboard" as the current tab

  Scenario: a user with accessAccounts privs goes to the dashboard and sees the accounts item
    Given I am logged into my account
    And I have "accessAccounts" privs
    When I go to the dashboard page
    Then I should see an "Accounts" dashboard item
    And I should see "Dashboard" as the current tab

  Scenario: a user with admin privs goes to the dashboard and sees the admin item
    Given I am logged into my account
    And I have "admin" privs
    When I go to the dashboard page
    Then I should see an "Admin" dashboard item
    And I should see "Dashboard" as the current tab
    
  Scenario: a user with dev privs goes to the dashboard and sees the admin item
    Given I am logged into my account
    And I have "dev" privs
    When I go to the dashboard page
    Then I should see an "Dev" dashboard item
    And I should see "Dashboard" as the current tab

