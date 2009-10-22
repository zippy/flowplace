Feature: circles
  In order to create boundaries between integral systems
  As a user
  I want to be a part of, and be able to create circles
  
  Background:
    Given I am logged into my account
    And a circle "the circle"

  Scenario: a new user can see this list of circles on the system and can get more info about them
    When I go to on the circles page
    Then I should see "the circle"
    When I follow "the circle"
    Then I should be taken to the show circle page for "the circle"

  Scenario: user creates a circle and sees it in the circles page and user is gatekeeper so can edit the circle
    When I go to the circles page
    And I follow "New circle"
    And I fill in "name" with "my circle"
    And I press "Create"
    Then I should be taken to the circles page
    And I should see "Circle was successfully created."
    And I should see "my circle"
    When I follow "my circle"
    Then I should be taken to the edit circle page for "my circle"
    When I go to the show circle page for "my circle"
    Then I should see "Anonymous User (anonymous) -- admin"

  Scenario: gatekeeper edits the description of a circle
    Given I am a "gatekeeper" of currency "the circle"
    When I go to the circles page
    When I follow "the circle"
    And I fill in "description" with "a very cool circle"
    And I press "Update"
    And I follow "the circle"
    Then I should see "a very cool circle"
  
  Scenario: gatekeeper deletes a circle
  
  Scenario: non-gatekeeper user fails to delete a cirle