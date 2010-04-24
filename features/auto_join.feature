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
