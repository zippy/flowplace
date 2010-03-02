Feature: Manage users
  In order to manage of users in the system
  As an Admin
  I want to be able admin all aspects of the users data

Background:
  And I am logged into my account
  And I have "admin" privs
  And I have "createAccounts" privs
  And I have "accessAccounts" privs
  And I have "assignPrivs" privs

  Scenario: Admin creates a new user
    When I go to the add user page
    And I fill in "Account Name" with "joe"
    And I fill in "First Name" with "Joe"
    And I fill in "Last Name" with "User"
    And I fill in "Email" with "jo@smith.org"
    And I fill in "Phone" with "123-456-789"
    And I fill in "Address 1" with "123 Main St"
    And I fill in "City" with "Smalltown"
    And I fill in "Zip" with "12345"
    And I press "Create"
    Then I should see "Account joe was created."

