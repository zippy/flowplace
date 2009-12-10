Feature: circles
  In order to participate in the constellation of integral systems
  As a user
  I want to be able to see and request admission to circles
  
  Background:
    Given I am logged into my account
    And a circle "the circle"
    When I go to the logout page

  Scenario: a new user explores the list of circles on the system and gets more info about them
    When I am logged into my "new" account
    And I go to the circles page
    And I should see "Circles" as the current tab
    And I should see "Browse" as the active sub-tab
    And I should see "the circle"
    When I follow "the circle"
    Then I should be taken to the show circle page for "the circle"
    And I should see "View" as the active sub-tab


