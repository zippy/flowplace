Feature: new user welcome
  In order ease into this whole currency thing
  As a new user
  I want to be welcomed and have easy steps to follow to start out using the systems
  
  Background:
    Given I am logged into my account
    And a circle "the circle"
    When I go to the logout page

  Scenario: a new users first login (leads to a welcome message on the flowplace dashboard)
    When I am logged into my "new" account
    Then I should be taken to the dashboard page
    And I should see "Dashboard" as the current tab
    And I should see a "Welcome" dashboard item


