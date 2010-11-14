Feature: invitations
  In order to go viral
  As a player
  I want to be able to invite my friends to my circles

  Background:
    Given the default site configurations
    Given I am logged into my account
    Given I have "circle" privs
    And a circle "the circle"
    When I make "anonymous" an "inviter" of "the circle"

  Scenario: Inviter makes an invite play to a user that already has an account
    And I go to the dashboard page
    And I follow "Invite" within "#dashboard_the_circle_inviter"
    And I fill in "play_email" with "notifications@harris-braun.com"
    And I fill in "play_text" with "Come out an play!"
    And I press "Record Play"
    Then I should be taken to the dashboard page
    And I should see /1 pending invitation:.*notifications@harris-braun.com/ within "#dashboard_the_circle_inviter"
    And I follow "Invite" within "#dashboard_the_circle_inviter"
    And I fill in "play_email" with "notifications@harris-braun.com"
    And I fill in "play_text" with "Come out an play, really!"
    And I press "Record Play"
    Then I should see "You have already sent an invitation to notifications@harris-braun.com"
    When I go to the logout page
    Given A user "joe" with email "notifications@harris-braun.com"
    And I go to the accept invitation from "anonymous" in "the circle" to "notifications@harris-braun.com" page
    Then I should be taken to the dashboard page
    And I should see "the circle"
    And I should see "You have been added to: the circle"
    When I go to the logout page
    Given I am logged into my account
    And I go to the dashboard page
    And I should see /1 accepted invitation:.*notifications@harris-braun.com \(joe\)/ within "#dashboard_the_circle_inviter"

  Scenario: Inviter makes an invite play to an email that has no account
    And I go to the dashboard page
    And I follow "Invite" within "#dashboard_the_circle_inviter"
    And I fill in "play_email" with "notifications@harris-braun.com"
    And I fill in "play_text" with "Come out an play!"
    And I press "Record Play"
    When I go to the logout page
    And I go to the accept invitation from "anonymous" in "the circle" to "notifications@harris-braun.com" page
    And I fill in "Account name" with "jane"
    And I fill in "First name:" with "Jane"
    And I fill in "Last name" with "Smith"
    And I fill in "Choose a Password" with "password"
    And I fill in "Password Confirmation" with "password"
    And I press "Accept Invitation"
    Then I should be taken to the dashboard page
    And I should see "the circle"
    When I go to the logout page
    Given I am logged into my account
    And I go to the dashboard page
    And I should see /1 accepted invitation:.*notifications@harris-braun.com \(jane\)/ within "#dashboard_the_circle_inviter"

  Scenario: Someone replies to a non-existent invitation
    When I go to the accept invitation from "anonymous" in "the circle" to "notifications@harris-braun.com" page
    Then I should be taken to the home page
