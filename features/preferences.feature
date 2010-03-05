Feature: Users
  In order that users can have an individually tailored and personal experience of the flowplace
  As a player
  I want there to be preferences

  Background:
    Given I am logged into my account

  Scenario: user views the preferences page
    When I go to the preferences page
    Then I should see /I know how the site works now.  Hide the long-winded instructions./
    And I should see /I don't like to squint.  Use a larger font size./

  Scenario: user sets the enlarge font preferences
    When I go to the preferences page
    Then I should not see a tag "body[class=enlargeFont]"
    And I check "prefs[enlargeFont]"
    And I press "Set Preferences"
    Then I should see a tag "body[class=enlargeFont]"

