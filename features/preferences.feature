Feature: Users
  In order that users can have an individually tailored and personal experience of the flowplace
  As a player
  I want there to be preferences

  Background:
    Given the default site configurations
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

  Scenario: user toggles the self-authorize circles currency preference
    When I go to the logout page
    And I am logged into my "admin" account
    And I have "admin" privs
    When I go to the configurations page
    And I follow "Circle Currency Policy"
    And I select "self_authorize" from "configuration_value"
    And I press "Update"
    Then I should not have "currency,circle" privs
    When I follow "Preferences"
    Then the "Activate circle and currency management features" checkbox should not be checked
    When I check "Activate circle and currency management features"
    And I press "Set Preferences"
    Then I should have "currency,circle" privs
    When I follow "Preferences"
    Then the "Activate circle and currency management features" checkbox should be checked
    When I uncheck "Activate circle and currency management features"
    And I press "Set Preferences"
    Then I should not have "currency,circle" privs
    When I follow "Preferences"
    Then the "Activate circle and currency management features" checkbox should not be checked
    
  Scenario: user enables the show circles as membrane currencies preference
    When I go to the logout page
    And I am logged into my "admin" account
    And I have "admin" privs
    When I go to the configurations page
    And I follow "Circle Currency Policy"
    And I select "self_authorize" from "configuration_value"
    And I press "Update"
    When I follow "Preferences"
    Then I should not see "Show circles as membrane currencies in the dashboard"
    When I go to the logout page
    And I am logged into my account
    Given I have "circle" privs
    And a circle "the circle"
    When I go to the dashboard page
    Then I should not see a "the circle" "namer" dashboard item
    Then I should not see a "the circle" "binder" dashboard item
    When I go to the preferences page
    Then I should see "Show circles as membrane currencies in the dashboard"
    When I check "prefs[showMembranes]"
    And I press "Set Preferences"
    And I go to the dashboard page
    Then I should see a "the circle" "namer" dashboard item
    Then I should see a "the circle" "binder" dashboard item

  Scenario: user changes language preference
    When I go to the preferences page
    Then "English" should be selected for "Language"
    When I select "French" from "Language"
    And I press "Set Preferences"
    And I go to the preferences page
    Then "French" should be selected for "Language"

  Scenario: user toggles the view self-authorize annotation preferences
    When I go to the logout page
    And I am logged into my "admin" account
    And I have "admin" privs
    When I go to the configurations page
    And I follow "Annotations Policy"
    And I select "self_authorize_view" from "configuration_value"
    And I press "Update"
    Then I should not have "view_annotations,edit_annotations" privs
    When I follow "Preferences"
    Then the "Activate view annotations feature" checkbox should not be checked
    When I check "Activate view annotations feature"
    And I press "Set Preferences"
    Then I should have "view_annotations" privs
    And I should not have "edit_annotations" privs
    When I follow "Preferences"
    Then the "Activate view annotations feature" checkbox should be checked
    When I uncheck "Activate view annotations feature"
    And I press "Set Preferences"
    Then I should not have "view_annotations,edit_annotations" privs
    When I follow "Preferences"
    Then the "Activate view annotations feature" checkbox should not be checked

  Scenario: user toggles the edit self-authorize annotation preferences
    When I go to the logout page
    And I am logged into my "admin" account
    And I have "admin" privs
    When I go to the configurations page
    And I follow "Annotations Policy"
    And I select "self_authorize_view_edit" from "configuration_value"
    And I press "Update"
    Then I should not have "view_annotations,edit_annotations" privs
    When I follow "Preferences"
    Then the "Activate view annotations feature" checkbox should not be checked
    And the "Activate edit annotations feature" checkbox should not be checked
    When I check "Activate edit annotations feature"
    And I press "Set Preferences"
    Then I should have "edit_annotations" privs
    When I follow "Preferences"
    Then the "Activate view annotations feature" checkbox should not be checked
    Then the "Activate edit annotations feature" checkbox should be checked
    When I uncheck "Activate edit annotations feature"
    And I press "Set Preferences"
    Then I should not have "edit_annotations" privs
    When I follow "Preferences"
    Then the "Activate view annotations feature" checkbox should not be checked
    And the "Activate edit annotations feature" checkbox should not be checked
 
    
