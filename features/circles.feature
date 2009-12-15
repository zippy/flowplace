Feature: circles
  In order to participate in the constellation of integral systems
  As a user
  I want to be able to see and request admission to circles
  
  Background:
    Given I am logged into my "matrice" account
    Given a circle "the circle" with members "joe,jane"
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

  Scenario: a new user who hasn't joined a circle doesn't see the jump pop-up
    When I am logged into my "new" account
    And I go to the flowplace dashboard page
    Then I should not see "Jump to"
    When I go to the dashboard page
    Then I should not see "Jump to"

  Scenario: a user navigates between their circles and the flowplace
    When I am logged into my "joe" account
    And I go to the flowplace dashboard page
    And I should see "Jump to"
    Then I select "Flowplace" from "Jump to"
    And I select "the circle" from "Jump to"
    When I go to the dashboard page
    Then I should see "Jump to"
    And I select "Flowplace" from "Jump to"
    And I select "the circle" from "Jump to"
    
  Scenario: a matrice navigates between her circles and the flowplace
    Given I am logged into my "matrice" account
    And I go to the flowplace dashboard page
    And I should see "Jump to"
    Then I select "Flowplace" from "Jump to"
    And I select "the circle" from "Jump to"
    When I go to the dashboard page
    Then I should see "Jump to"
    And I select "Flowplace" from "Jump to"
    And I select "the circle" from "Jump to"
