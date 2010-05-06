Feature: demo-interface
  In order to simplify the site for presentation purposes
  As an admin
  I want a demo interface that removes circles

  Background:
    Given the default site configurations
    And I am logged into my account
    And I have "admin" privs
    And I go to the configurations page
    And I follow "Single Circle"
    And I select "on" from "configuration_value"
    And I press "Update"
    And I have "circle" privs
    And a circle "the circle" with members "joe,jane"
    And I go to the logout page

  Scenario: circle members logs in and navigates the dashboard
    And I am logged into my "joe" account
    Then I should be taken to the dashboard page
    And I should not see "Jump to"

  Scenario: player creates a currency and all members are autojoined to it
    Given I am logged into my "joe" account
    When I go to the dashboard page
    Then I should see "Create Currency"
    When I follow "Create Currency"
    Then I should be taken to the new currencies page
    When I go to the new "MutualCredit" currencies page
    Then I should be taken to the new "MutualCredit" currencies page
    When I fill in "Name" with "LETS"
    And I press "Create"
    Then I should be taken to the dashboard page
    And I should see a "LETS" "member" dashboard item
    
