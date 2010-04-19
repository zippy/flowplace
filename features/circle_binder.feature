Feature: circle binder
  In order to create connect up circles
  As a binder
  I want be able to request and and manage bindings between circles
  
  Background:
    Given I am logged into my account
    Given I have "circle" privs
    And a circle "the circle"
  
  Scenario: binder views her circle's currencies
    When I go to the circles page
    And I follow "Add Currencies" within "table"
    Then I should be taken to the currencies page for "the circle"
    And I should see "Add Currencies" as the active sub-tab
    And I should see "Add Players" as a sub-tab
    And I should see "View" as a sub-tab
    And I should see "Edit" as a sub-tab
    And I should see "There are no currencies in this circle."

  Scenario: binder binds a currency to a circle
    When I go to the "binder" currency account history page for "anonymous" in "the circle" of "bind_currency"
    Then I should see "You have made no 'bind_currency' plays in this currency."
    Given a "MutualCredit" currency "X"
    When I go to the currencies page for "the circle"
    When I check the box for currency "X"
    And I press "Add >>"
    Then I should be taken to the currencies page for "the circle"
    And I should see "Circle was successfully updated."
    And I should not see "There are no currencies in this circle."
    And I should see "X" in row 1 column 0 within "#circle_currencies"
    When I go to the "binder" currency account history page for "anonymous" in "the circle" of "bind_currency"
    Then I should see a table with 2 rows

  Scenario: binder binds a currency to a circle forgetting to check a currency
    Given a "MutualCredit" currency "X"
    When I go to the currencies page for "the circle"
    And I press "Add >>"
    Then I should see "You must choose some currencies!"

  Scenario: binder releases a currency from a circle
    When I go to the "binder" currency account history page for "anonymous" in "the circle" of "unbind_currency"
    Then I should see "You have made no 'unbind_currency' plays in this currency."
    Given a "MutualCredit" currency "X"
    And I bind "X" to "the circle"    
    When I go to the currencies page for "the circle"
    When I check the box for bound currency "X"
    And I press "<< Remove"
    Then I should be taken to the currencies page for "the circle"
    And I should see "Circle was successfully updated."
    And I should see "There are no currencies in this circle."
    When I go to the "binder" currency account history page for "anonymous" in "the circle" of "unbind_currency"
    Then I should see a table with 2 rows
    