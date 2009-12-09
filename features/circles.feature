Feature: circles
  In order to create boundaries between integral systems
  As a user
  I want to be a part of, and be able to create circles
  
  Background:
    Given I am logged into my account
    And a circle "the circle"

  Scenario: a new user can see this list of circles on the system and can get more info about them
    When I go to the logout page
    And I am logged into my "new" account
    When I go to on the circles page
    Then I should see "the circle"
    When I follow "the circle"
    Then I should be taken to the show circle page for "the circle"
    And I should see "View" as the active sub-tab


