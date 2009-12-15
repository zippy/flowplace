Feature: circle matrice
  In order to create boundaries that relate integral systems
  As a matrice
  I want be able to create and manage circles
  
  Background:
    Given I am logged into my account
    And a circle "the circle"

  Scenario: user creates a circle and sees it in the circles page and user is matrice so can edit the circle and a user should be created for the circle
    When I go to the circles page
    And I follow "New circle"
    And I fill in "name" with "my circle"
    And I fill in "password" with "password"
    And I fill in "confirmation" with "password"
    And I press "Create"
    Then I should be taken to the circles page
    And I should see "Circle was successfully created."
    And I should see "my circle"
    When I follow "my circle"
    Then I should be taken to the edit circle page for "my circle"
    When I go to the show circle page for "my circle"
    Then I should see "Anonymous User (anonymous) -- matrice"
    When I go to the logout page
    And I log in as "my_circle_circle"
    And I go to the my currencies page
    Then I should see "my circle"
    And I should see "self"

  Scenario: user tries to create a circle but enters mismatched password
    When I go to the circles page
    And I follow "New circle"
    And I fill in "name" with "my circle"
    And I fill in "password" with "password"
    And I fill in "confirmation" with "xxx"
    And I press "Create"
    And I should see "Passwords don't match"
    When I go to the circles page
    And I should not see "my circle"

  Scenario: matrice edits the description of a circle
    Given I am a "matrice" of currency "the circle"
    When I go to the circles page
    And I follow "the circle"
    Then I should see "Edit" as the active sub-tab
    And I should see "View" as a sub-tab
    And I should see "Players" as a sub-tab
    And I should see "Currencies" as a sub-tab
    When I fill in "description" with "a very cool circle"
    And I press "Update"
    And I follow "the circle"
    Then I should see "a very cool circle"

  Scenario: a non-matrice user tries to go to a circle's players,edit and currency pages and fails
    When I go to the logout page
    And I am logged into my "new" account
    When I go to the players page for "the circle"
    Then I should be taken to the home page
    And I should see "You don't have permission to do that."
    When I go to the edit circle page for "the circle"
    Then I should be taken to the home page
    And I should see "You don't have permission to do that."
    When I go to the currencies page for "the circle"
    Then I should be taken to the home page
    And I should see "You don't have permission to do that."

  Scenario: matrice views her circle's players
    When I go to the circles page
    And I follow "Players" within "table"
    And I should see "Players" as the active sub-tab
    And I should see "View" as a sub-tab
    And I should see "Currencies" as a sub-tab
    And I should see "Edit" as a sub-tab
    And I should see a table with 3 rows
    And I should see "User" in row 0 column 0
    And I should see "Role" in row 0 column 1
    And I should see "the_circle_circle" in row 1 column 0
    And I should see "self" in row 1 column 1
    And I should see "Anonymous User (anonymous)" in row 2 column 0
    And I should see "matrice" in row 2 column 1
  
  Scenario: matrice searches for a user not in a circle
    Given A user "user1"
    When I go to the players page for "the circle"
    Then I should not see "user1"
    When I select "Account name contains" from "search_on_main"
    And I fill in "search_for_main" with "user1"
    And I press "Search"
    Then I should be taken to the players page for "the circle"
    And I should see "user1" in row 1 column 0
    And I should see "--" in row 1 column 1

  Scenario: matrice searches for a non existent user
    When I go to the players page for "the circle"
    And I fill in "search_for_main" with "user1"
    And I press "Search"
    Then I should be taken to the players page for "the circle"
    And I should see "No accounts found"

  Scenario: matrice adds a new user as member to a circle
    Given A user "joe"
    When I go to the players page for "the circle"
    When I select "Account name contains" from "search_on_main"
    And I fill in "search_for_main" with "joe"
    And I press "Search"
    And I should see "joe" in row 1 column 0
    And I should see "--" in row 1 column 1
    When I check the box for "joe"
    When I select "member" from "player_class"
    And I press "Submit"
    Then I should see "Circle was successfully updated."
    And I should see "joe" in row 1 column 0
    And I should see "member" in row 1 column 1
    And There should be a play in my currencies history that reflects this

#this scenario also tests that when the user is redirected back to the players page
# that the default set of users (i.e. the ones in the circle) are rendered, instead of
# the ones in the session from a search.
  Scenario: matrice adds existing user as member to a circle
    When I go to the players page for "the circle"
    When I check the box for "anonymous"
    When I select "member" from "player_class"
    And I press "Submit"
    Then I should see "Circle was successfully updated."
    And I should see "anonymous" in row 2 column 0
    And I should see "matrice, member" in row 2 column 1
  
  Scenario: matrice sees errors when not choosing user or player class when attempting to add to a circle
    When I go to the players page for "the circle"
    And I press "Submit"
    Then I should see "You must choose a role!"
    Then I should see "You must choose some users!"
    
  Scenario: matrice views her circle's currencies
    When I go to the circles page
    And I follow "Currencies" within "table"
    Then I should see "Currencies" as the active sub-tab
    And I should see "Players" as a sub-tab
    And I should see "View" as a sub-tab
    And I should see "Edit" as a sub-tab
    And I should see "There are no currencies in this circle."
  
  Scenario: matrice binds a currency to a circle
    Given a "MutualCredit" currency "X"
    When I go to the "bind_currency" play page for my "matrice" account in "the circle"
    And I select "X" from "play_currency"
    And I select "the_circle_circle" from "play_to"
    And I fill in "play_name" with "X"
    And I press "Record Play"
    Then I should see "The play was recorded."

  Scenario: matrice can delete a circle but a non-matrice cannot
    When I go to the circles page
    And I should see a table with 1 rows
    And I should see "Delete" in row 0 column 3
    When I go to the logout page
    And I am logged into my "new" account
    When I go to the circles page
    Then I should not see "Delete" in row 0 column 3
