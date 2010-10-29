Feature: circle namer
  In order to create boundaries that relate integral systems
  As a namer
  I want be able to create and manage circles
  
  Background:
    Given I am logged into my account
    Given I have "circle" privs
    And a circle "the circle"

  Scenario: user without circle permissions tries to go to circle functions
    When I go to the logout page
    Given A user "joe"
    And I log in as "joe"
    When I go to the new circles page
    Then I should be taken to the dashboard page
    
  Scenario: user creates a circle and sees it in the circles page and user is namer so can edit the circle and a user should be created for the circle
    When I go to the circles page
    And I follow "New"
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
    Then I should see "Anonymous User (anonymous) -- namer"
    When I go to the logout page
    And I log in as "my_circle_circle"
    Then I should be taken to the dashboard page
    And I should see "my circle" as a "Jump to" option

  Scenario: user tries to create a circle but enters mismatched password
    When I go to the circles page
    And I follow "New"
    And I fill in "name" with "my circle"
    And I fill in "password" with "password"
    And I fill in "confirmation" with "xxx"
    And I press "Create"
    And I should see "Passwords don't match"
    When I go to the circles page
    And I should not see "my circle"

  Scenario: namer edits the description of a circle
    Given I am a "namer" of currency "the circle"
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

  Scenario: a non-namer with circle perms tries to go to a circle's players,edit and currency pages and fails
    When I go to the logout page
    And I am logged into my "new" account
    And I have "circle" privs
    When I go to the players page for "the circle"
    Then I should be taken to the home page
    And I should see "You don't have permission to do that."
    When I go to the edit circle page for "the circle"
    Then I should be taken to the home page
    And I should see "You don't have permission to do that."
    When I go to the currencies page for "the circle"
    Then I should be taken to the home page
    And I should see "You don't have permission to do that."

  Scenario: namer views her circle's players
    When I go to the circles page
    And I follow "Add Players" within "table"
    And I should see "Add Players" as the active sub-tab
    And I should see "View" as a sub-tab
    And I should see "Currencies" as a sub-tab
    And I should see "Edit" as a sub-tab
    And I should see a table with 3 rows within "#circle_players"
    And I should see "Player" in row 0 column 0 within "#circle_players"
    And I should see "Anonymous User as namer" in row 1 column 0 within "#circle_players"
    And I should see "Anonymous User as binder" in row 2 column 0 within "#circle_players"
    And I should see "namer" in row 1 column 1 within "#circle_players"
    And I should see "binder" in row 2 column 1 within "#circle_players"
  
  Scenario: namer searches for a users to add
    Given A user "jeff"
    Given A user "fred"
    When I go to the players page for "the circle"
    Then I should see "Search found 4 users"
    And I should see "Search"
    And I fill in "search_key" with "jeff"
    And I press "Search"
    Then I should be taken to the players page for "the circle"
    And I should see "jeff" in row 1 column 0 within "#circle_users_search_results"
    And I should see "Search found 1 user"
    When I fill in "search_key" with "f"
    And I press "Search"
    Then I should see "Search found 2 users"

  Scenario: namer searches for a non existent user
    When I go to the players page for "the circle"
    And I fill in "search_key" with "userx"
    And I press "Search"
    Then I should be taken to the players page for "the circle"
    And I should see "No users found"

  Scenario: namer adds a new user as member to a circle
    When I go to the "namer" currency account history page for "anonymous" in "the circle" of "name_member"
    Then I should see "You have made no 'name_member' plays in this currency"
    Given A user "joe"
    When I go to the players page for "the circle"
    When I check the box for user "joe"
    When I select "member" from "player_class"
    And I press "Add >>"
    Then I should see "Circle was successfully updated."
    And I should see "Joe User as member" in row 3 column 0 within "#circle_players"
    And I should see "member" in row 3 column 1 within "#circle_players"
    When I go to the "namer" currency account history page for "anonymous" in "the circle" of "name_member"
    Then this should be working
#    Then I should see a table with 2 rows

#this scenario also tests that when the user is redirected back to the players page
# that the default set of users (i.e. the ones in the circle) are rendered, instead of
# the ones in the session from a search.
  Scenario: namer adds existing user as member to a circle
    When I go to the players page for "the circle"
    Then I should see a table with 3 rows within "#circle_players"
    When I check the box for user "anonymous"
    When I select "member" from "player_class"
    And I press "Add >>"
    Then I should see "Circle was successfully updated."
    And I should see a table with 4 rows within "#circle_players"
    And I should see "Anonymous User as namer" in row 1 column 0 within "#circle_players"
    And I should see "Anonymous User as member" in row 3 column 0 within "#circle_players"
  
  Scenario: namer sees errors when not choosing user or player class when attempting to add to a circle
    When I go to the players page for "the circle"
    And I press "Add >>"
    Then I should see "You must choose a role!"
    Then I should see "You must choose some users!"

  Scenario: namer adds a user as namer to a circle and then later also as a member and sees the diff re linking
    Given A user "joe"
    When I go to the players page for "the circle"
    When I check the box for user "joe"
    When I select "namer" from "player_class"
    And I press "Add >>"
    Then I should see "Circle was successfully updated."
    And I should see "Joe User as namer" in row 3 column 0 within "#circle_players"
    When I go to the link players page for "the circle"
    Then I should not see "Joe User"
    When I go to the players page for "the circle"
    When I check the box for user "joe"
    When I select "member" from "player_class"
    And I press "Add >>"
    When I go to the link players page for "the circle"
    Then I should see "Joe User"

  Scenario: namer removes a user from a circle
    Given A user "joe"
    And I make "joe" a "member" of "the circle"
    When I go to the players page for "the circle"
    And I check the box for player "joe" as "member"
    And I press "<< Remove"
    Then I should see "Circle was successfully updated."

  Scenario: namer looks at users to be linked to currencies
    Given a "MutualCredit" currency "X"
    And I bind "X" to "the circle"    
    And A user "joe"
    And A user "jane"
    And A user "jack"
    When I make "joe" a "member" of "the circle"
    When I make "jane" a "member" of "the circle"
    When I go to the circles page
    And I follow "Link Players to Currencies" within "table"
    Then I should be taken to the link players page for "the circle"
    And I should see "Link Players to Currencies" as the active sub-tab
    And I should see "Add Players" as a sub-tab
    And I should see "View" as a sub-tab
    And I should see "Edit" as a sub-tab
    And I should see "Joe User" within "#circle_users_search_results"
    And I should see "Jane User" within "#circle_users_search_results"
    And I should not see "Jack User" within "#circle_users_search_results"
    And I should see "X" within "#circle_currencies"
    And I should see "member" within "#circle_currencies"

  Scenario: namer grants a user a role in a currency
    Given a "MutualCredit" currency "X"
    And I bind "X" to "the circle"
    Given a "MutualCredit" currency "Y"
    And I bind "Y" to "the circle"
    And A user "joe"
    When I make "joe" a "member" of "the circle"
    And I go to the link players page for "the circle"
    Then I should see "not linked to any currencies" within "#joe"
    And I check the box for user "joe"
    #if webrat wasn't whack this should be, but in this test case it is unambiguous.
    #And I check "Member" within "#currency_x"
    And I check "currencies[2][member]"
    And I press "Link"
    Then I should be taken to the link players page for "the circle"
    And I should see "member" within "#joe"

  Scenario: namer grants a role forgetting to check a user
    Given a "MutualCredit" currency "X"
    And I bind "X" to "the circle"
    And A user "joe"
    When I make "joe" a "member" of "the circle"
    And I go to the link players page for "the circle"
    And I check "currencies[2][member]"
    And I press "Link"
    And I should see "You must choose some players!"

  Scenario: namer re-grants a role forgetting to check a user
    Given a "MutualCredit" currency "X"
    And I bind "X" to "the circle"
    And A user "joe"
    When I make "joe" a "member" of "the circle"
    And I go to the link players page for "the circle"
    And I check the box for user "joe"
    And I check "currencies[2][member]"
    And I press "Link"
    And I check the box for user "joe"
    And I check "currencies[2][member]"
    And I press "Link"
    And I should see "member" within "#joe"

  Scenario: namer revokes a user's role in a currency
    Given a "MutualCredit" currency "X"
    And I bind "X" to "the circle"
    And A user "joe"
    And I make "joe" a "member" of "the circle"
    And "joe" is a "member" of currency "X"
    And I go to the link players page for "the circle"
    Then I should see "member" within "#joe"
    When I check the box for user "joe"
    And I check "currencies[2][member]"
    And I press "Unlink"
    Then I should see "not linked to any currencies" within "#joe"

  Scenario: namer searches for a users to link
    Given a "MutualCredit" currency "X"
    And I bind "X" to "the circle"
    And A user "joe"
    And I make "joe" a "member" of "the circle"
    And "joe" is a "member" of currency "X"
    And A user "fred"
    And I make "fred" a "member" of "the circle"
    And "fred" is a "member" of currency "X"
    And I go to the link players page for "the circle"
    Then I should see "Search found 2 users"
    And I should see "Search"
    And I fill in "search_key" with "joe"
    And I press "Search"
    And I should be taken to the link players page for "the circle"
    And I should see "Search found 1 user"
    And I should see "joe" in row 1 column 0 within "#circle_users_search_results"

  Scenario: namer works in a situation with many users
    Given a "MutualCredit" currency "X"
    And I bind "X" to "the circle"
    And A user "joe"
    And A user "jane"
    When I go to page 1 of the players page for "the circle" with 3 per page
    Then I should see "joe"
    And I should not see "jane"
    When I follow "Next"
    Then I should see "jane"
    And I should not see "joe"
    When I make "joe" a "member" of "the circle"
    When I make "jane" a "member" of "the circle"
    When I go to page 1 of the link players page for "the circle" with 1 per page
    Then I should see "jane"
    And I should not see "joe"
    When I follow "Next"
    Then I should see "joe"
    And I should not see "jane"
    
  Scenario: namer can delete a circle but a non-namer cannot
    When I go to the circles page
    And I should see a table with 1 rows
    And I should see "Delete" in row 0 column 3
    When I go to the logout page
    And I am logged into my "new" account
    When I go to the circles page
    Then I should not see "Delete" in row 0 column 3

  Scenario: namer deletes a circle and then creates it again
    When I go to the circles page
    Then I should see "the circle"
    And I follow "Delete"
    Then I should see "There are no circles defined yet."
    When I go to the circles page
    And I follow "New"
    And I fill in "name" with "the circle"
    And I fill in "password" with "password"
    And I fill in "confirmation" with "password"
    And I press "Create"
    When I go to the circles page
    Then I should see "the circle"

  Scenario: namer doesn't see currencies not stewarded by her
    When I go to the logout page
    Given I have an account as "Jane"
    And an "Issued" currency "THEM"
    When I go to the logout page
    And I am logged into my account
    When I go to the currencies page for "the circle"
    Then I should see "No currencies found"

  Scenario: namer renames a circle
    Given a "MutualCredit" currency "X"
    And I bind "X" to "the circle"    
    And I make "the_circle_circle" a "member" of "the circle"
    And I make "anonymous" a "member" of "the circle"
    And "the_circle_circle" is a "member" of currency "X"
    And "anonymous" is a "member" of currency "X"
    When I go to the edit circle page for "the circle"
    And I fill in "Name" with "circle x"
    And I press "Update"
    And I should see "Circle was successfully updated."
    And I should see "circle x"
    When I go to the dashboard page
    Then I should see a "X" "member" dashboard item
    When I go to the logout page
    And I log in as "circle_x_circle"
    Then I should be taken to the dashboard page

  Scenario: namer views her circle's currencies
    When I go to the circles page
    And I follow "Add Currencies" within "table"
    Then I should be taken to the currencies page for "the circle"
    And I should see "Add Currencies" as the active sub-tab
    And I should see "Add Players" as a sub-tab
    And I should see "View" as a sub-tab
    And I should see "Edit" as a sub-tab
    And I should see "There are no currencies in this circle."

  Scenario: namer binds a currency to a circle
    When I go to the "namer" currency account history page for "anonymous" in "the circle" of "bind_currency"
    Then I should see "You have made no 'bind_currency' plays in this currency."
    Given a "MutualCredit" currency "X"
    When I go to the currencies page for "the circle"
    When I check the box for currency "X"
    And I press "Add >>"
    Then I should be taken to the currencies page for "the circle"
    And I should see "Circle was successfully updated."
    And I should not see "There are no currencies in this circle."
    And I should see "X" in row 1 column 0 within "#circle_currencies"
    When I go to the "namer" currency account history page for "anonymous" in "the circle" of "bind_currency"
    Then I should see a table with 2 rows

  Scenario: namer binds a currency to a circle as autojoin
    When I go to the "namer" currency account history page for "anonymous" in "the circle" of "bind_currency"
    Then I should see "You have made no 'bind_currency' plays in this currency."
    Given a "MutualCredit" currency "X"
    When I go to the currencies page for "the circle"
    When I check the box for currency "X"
    And I check "Autojoin"
    And I press "Add >>"
    Then I should be taken to the currencies page for "the circle"
    And I should see "Circle was successfully updated."
    And I should not see "There are no currencies in this circle."
    And I should see "X (autojoin)" in row 1 column 0 within "#circle_currencies"
    Given A user "joe"
    When I go to the players page for "the circle"
    When I check the box for user "joe"
    When I select "member" from "player_class"
    And I press "Add >>"
    And I go to the link players page for "the circle"
    Then I should see "member" within "#joe"

  Scenario: namer binds a currency to a circle forgetting to check a currency
    Given a "MutualCredit" currency "X"
    When I go to the currencies page for "the circle"
    And I press "Add >>"
    Then I should see "You must choose some currencies!"

  Scenario: namer releases a currency from a circle
    When I go to the "namer" currency account history page for "anonymous" in "the circle" of "unbind_currency"
    Then I should see "You have made no 'unbind_currency' plays in this currency."
    Given a "MutualCredit" currency "X"
    And I bind "X" to "the circle"    
    When I go to the currencies page for "the circle"
    When I check the box for bound currency "X"
    And I press "<< Remove"
    Then I should be taken to the currencies page for "the circle"
    And I should see "Circle was successfully updated."
    And I should see "There are no currencies in this circle."
    When I go to the "namer" currency account history page for "anonymous" in "the circle" of "unbind_currency"
    Then I should see a table with 2 rows    
