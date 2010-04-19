Feature: currencies
  In order to coordinate and make visible the flows of working together
  As a user
  I want to be able to add currencies to the flowplace

  Background:
    Given I have an account as "Jane"
    Given I am logged into my "Joe" account
    And I have "currency" privs
    And a circle "the circle"
    And an "Issued" currency "THEM"

  Scenario: user creates a new currency
    When I go to the new currencies page
    And I fill in "Name" with "WE"
    And I select "Mutual Credit" from "Type"
    And I fill in "Icon url" with "/images/currency_icon_we.jpg"
    And I press "Create"
    Then I should be taken to the currencies page
    And I should see "WE"
    And I should see the "/images/currency_icon_we.jpg" image

  Scenario: user creates a new currency without specifying the type and get's an error message
    When I go to the new currencies page
    And I fill in "Name" with "WE"
    And I fill in "Icon url" with "/images/currency_icon_we.jpg"
    And I press "Create"
    Then I should see "Type can't be blank"
  
  Scenario: user examines the currency types pop-up
    When I go to the new currencies page
    Then I should see "Mutual Credit" as a "Type" option
    Then I should not see "Membrane" as a "Type" option

  Scenario: looks at the list of currencies and doesn't see membrane currencies
    When I go to the currencies page
    Then I should see "THEM" within "#currency_list"
    Then I should not see "the circle" within "#currency_list"

  Scenario: steward changes the ownership of a currency
    When I go to the currencies page
    Then I should see "THEM" within "#currency_list"
    When I follow "THEM"
    Then I should see "THEM:"
    And I should see "Edit Currency"
    When I select "Jane User" from "Steward"
    And I press "Update"
    Then I should be taken to the currencies page
    Then I should see "You currently steward no currencies."

  Scenario: admins sees all currencies
    Given I go to the logout page
    And I am logged into my "Jane" account
    And I have "currency" privs
    And I go to the currencies page
    Then I should see "You currently steward no currencies."
    Given I have "admin" privs
    When I go to the currencies page
    Then I should see "THEM" within "#currency_list"
    
  Scenario: user tries to access currency they don't steward and fails, but admin succeeds
    Given I go to the logout page
    And I am logged into my "Jane" account
    And I have "currency" privs
    When I go to the edit currency page for "THEM"
    Then I should be taken to the home page
    Given I have "admin" privs
    When I go to the edit currency page for "THEM"
    Then I should be taken to the edit currency page for "THEM"

  Scenario: steward renames a currency
    When I go to the currencies page
    And I follow "THEM"
    And I fill in "Name" with "WE"
    And I press "Update"
    Then I should see "WE" within "#currency_list"
