Feature: Intentions
  In order that my intentions can build wealth in the community
  As a player
  I want to be able to declare and manage my intentions in the system

	Background:
		Given I am logged into my account
  
  Scenario: Declaring an intention
    When I go to the new intentions page
    And I fill in "Title" with "intention 1"
    And I fill in "Description" with "intention 1 description"
    And I press "Declare"
    Then I should be taken to the intentions list
		And I should see "intention 1"
