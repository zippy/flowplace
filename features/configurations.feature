Feature: configuration
  In order to customize site behavior
  As an admin
  I want to be able to see and edit all the flowplace configuration options
  
  Background:
    Given the default site configurations
    And I am logged into my account
    And I have "admin" privs

  Scenario: admin looks at all the configuration options
    When I go to the configurations page
    Then I should be taken to the configurations page
    Then I should see "Config" as the current tab
    And I should see "Global Banner"
    And I should see "New User Policy"
    And I should see "Welcome Text"
    And I should see "Analytics"
    And I should see "Footer"
    And I should see "Site Name"

  Scenario: non-admin user tries to look at configuration options
    When I go to the logout page
    And I am logged into my "user" account
    And I go to the configurations page
    Then I should be taken to the dashboard page

  Scenario: admin changes the footer configuration
    When I go to the configurations page
    And I follow "Footer"
    And fill in "configuration_value" with "Powered by the Flowplace!"
    And I press "Update"
    Then I should see "Powered by the Flowplace!" within "#footer"

  Scenario: admin changes the site name
    Given I have "circle" privs
    And a circle "the circle" with members "admin"
    When I go to the configurations page
    And I follow "Site Name"
    And fill in "configuration_value" with "Cool Site"
    And I press "Update"
    Then I should see "Cool Site" within "#circle_header_name"
    And I should see "Cool Site" within "title"
    And I should see link with title "configure the Cool Site"
    And I select "Cool Site" from "Jump to"
    When I go to the logout page
    Then I should see "Thanks for being part of the Cool Site!"
    When I go to the forgot password page
    Then I should see "the one you use for the Cool Site web site"
    And I should see "please be sure to give us the one you used to sign up for the Cool Site"

  Scenario: admin merges new defaults
    Given all configurations are deleted
    When I go to the configurations page
    Then I should see a table with 1 row
    When I go to the merge default configurations page
    And I go to the configurations page
    Then I should see a table with 8 rows
    
  