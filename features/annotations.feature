Feature: annotations
  In order to build collaborative documentation and thinking about the site in general
  As a user
  I want to be able read and write annotations on all pages

  Background:
    Given I am logged into my account
    And I have "view_annotations,edit_annotations" privs
    
  Scenario: User adds an annotation to the dashboard page but not the preferences page
    When I go to the dashboard page
    Then I should see an image with title "Add an annotation"
    When I follow "Add an annotation"
    And I fill in "body" with "this is the dashboard page"
    And I press "Save"
    Then I should be taken to the dashboard page
    When I go to the dashboard page
    Then I should see an image with title "View annotations"
    When I follow "View annotations"
    Then I should see "this is the dashboard page" within "#annotation"
    When I follow "edit annotation"
    And I fill in "body" with "this is the nice dashboard page"
    And I press "Save"
    And I follow "View annotations"
    Then I should see "this is the nice dashboard page" within "#annotation"
    When I go to the preferences page
    And I follow "Add an annotation"
    Then the "body" field should not contain "this is the dashboard page"

  Scenario: User with various annotation privs tries to do stuff
    When I go to the dashboard page
    When I follow "Add an annotation"
    And I fill in "body" with "this is the dashboard page"
    And I press "Save"
    Then I should see an image with title "View annotations"
    When I go to the logout page
    And A user "joe"
    And I log in as "joe"
    When I go to the dashboard page
    Then I should not see an image with title "View annotations"
    And I have "view_annotations" privs
    When I go to the dashboard page
    Then I should see an image with title "View annotations"

  Scenario: User adds an annotation to a currency account page
    Given I have "circle,currency" privs
    Given a circle "the circle"
    When I go to the new "MutualCredit" currencies page
    When I fill in "Name" with "LETS"
    And I press "Create"
    And I should see "LETS"
    And I bind "LETS" to "the circle"
    When I make "anonymous" a "member" of "the circle"
    Given "anonymous" is a "member" of currency "LETS"
    And I go to the dashboard page
    And I follow "Pay"
    And I follow "Add an annotation"
    Then I should see "Annotation for: /currency_accounts/*LETS*/play/pay"
    And I fill in "body" with "this is the lets play page"
    And I press "Save"
    Then I should be taken to the "pay" play page for my "member" account in "LETS"
    Given A user "jane"
    And I make "jane" a "member" of "the circle"
    And "jane" is a "member" of currency "LETS"
    When I go to the logout page
    And I log in as "jane"
    And I have "view_annotations" privs
    And I go to the dashboard page
    And I follow "Pay"
    When I follow "View annotations"
    Then I should see "this is the lets play page" within "#annotation"
    
