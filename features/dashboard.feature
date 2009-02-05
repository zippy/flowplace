Feature: Dashboard
  In order that users can have an overview of the system
  As a player
  I want to be able to see it all

	Scenario: Dashboard contents
 		Given I am on the dashboard page
		Given I am logged in
 		Given I am on the dashboard page
		Then I should see "Manage your account and preferences" 
