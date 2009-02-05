Feature: Intentions
  In order that my intentions can build wealth in the community
  As a player
  I want to be able to place and mange my intentions in the system
  
  Scenario: Place an intention
    Given I am on the new intentions page
    When I fill in "Title" with "intention 1"
    And I fill in "Description" with "intention 1 description"
    And I press "Place"
    Then I should be take to the intentions list
		And I should see "intention 1"
