Feature: currencies
  In order to coordinate and make visible the flows of working together
  As a user
  I want to be able to add currencies to the flowplace

  Background:
    Given I am logged into my account

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
