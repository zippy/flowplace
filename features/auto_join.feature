Feature: auto_join
  In order start users out in the right place
  As an admin
  I want to be configure the site to automatically join new-users to currency/circle constellations
  
  Background:
    Given the default site configurations
    And A user "joe"
    And I am logged into my account
    And a circle "the circle"
    And I have "admin" privs
    And I have "createAccounts" privs
    And I have "accessAccounts" privs

  Scenario: admin sets up auto-join for a circle
    When I go to the configurations page
    And I follow "Autojoin"
    And fill in "configuration_value" with "circles: the circle"
    And I press "Update"
    And I go to the edit user page for "joe"
    And I check "autojoin"
    And I press "Update"
    Then I should see "autojoined Joe User"
    When I go to the logout page
    And I log in as "joe"
    Then I should see "the circle" as a "Jump to" option

  Scenario: admin misconfigures auto-join with invalid YAML
    When I go to the configurations page
    And I follow "Autojoin"
    And fill in "configuration_value" with " : "
    And I press "Update"
    Then I should see "Value must be valid YAML"
    
  Scenario: admin misconfigures auto-join with a non-existent circle
    When I go to the configurations page
    And I follow "Autojoin"
    And fill in "configuration_value" with "circles: thex"
    And I press "Update"
    And I go to the edit user page for "joe"
    And I check "autojoin"
    And I press "Update"
    Then I should see "error: circle thex not found!"

  Scenario: admin tries to run autojoin for a user when auto-join not configured
    And I go to the edit user page for "joe"
    And I check "autojoin"
    And I press "Update"
    Then I should see "autojoin configuration is empty"
 
  Scenario: admin runs autojoin for a user and sees that new users are auto-added to the configured circles
    When I go to the configurations page
    And I follow "Autojoin"
    And fill in "configuration_value" with "circles: the circle"
    And I press "Update"
    Given admin creates a user "bob"
    When I go to the logout page
    And I log in as "bob"
    Then I should see "the circle" as a "Jump to" option

  Scenario: a user creates an account and is joined to the circle and its member currencies
    Given a "MutualCredit" currency "X"
    And I bind "X" to "the circle" with autojoin on
    When I go to the configurations page
    And I follow "Autojoin"
    And fill in "configuration_value" with "circles: the circle"
    And I press "Update"
    And I follow "New User Policy"
    And I select "self_signup" from "configuration_value"
    And I press "Update"
    When I go to the logout page
    And I go to the sign up page
    Then I should be taken to the sign up page
    And I fill in "Account name" with "jane"
    And I fill in "First name:" with "Jane"
    And I fill in "Last name" with "Smith"
    And I fill in "E-mail" with "notifications@harris-braun.com"
    And I press "Sign up"
    And I go to the user activation page
    And I fill in "Choose a Password" with "password"
    And I fill in "Password Confirmation" with "password"
    And I press "Activate"
    Then I should be taken to the dashboard page
    Then I should see "the circle" as a "Jump to" option
    And I should see a "X" "member" dashboard item

  Scenario: a user creates an account and is joined to the circle and its member currencies even when circles have overlapping currencies
    Given a circle "another circle"
    Given a "MutualCredit" currency "X"
    And I bind "X" to "the circle" with autojoin on
    And I bind "X" to "another circle" with autojoin on
    When I go to the configurations page
    And I follow "Autojoin"
    And fill in "configuration_value" with "circles: the circle,another circle"
    And I press "Update"
    And I follow "New User Policy"
    And I select "self_signup" from "configuration_value"
    And I press "Update"
    When I go to the logout page
    And I go to the sign up page
    Then I should be taken to the sign up page
    And I fill in "Account name" with "jane"
    And I fill in "First name:" with "Jane"
    And I fill in "Last name" with "Smith"
    And I fill in "E-mail" with "notifications@harris-braun.com"
    And I press "Sign up"
    And I go to the user activation page
    And I fill in "Choose a Password" with "password"
    And I fill in "Password Confirmation" with "password"
    And I press "Activate"
    Then I should see "the circle" as a "Jump to" option
    Then I should see "another circle" as a "Jump to" option
    When I go to the dashboard page for "the circle"
    And I should see a "X" "member" dashboard item
    When I go to the dashboard page for "another circle"
    And I should see a "X" "member" dashboard item
