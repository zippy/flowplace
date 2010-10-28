Feature: acknowledgement currency
  In order to express acknowledgements like thankfulness
  As a player
  I want to be able give people various types of acknowlegements

  Background:
    Given I am logged into my account
    Given I have "circle,currency" privs
    Given a circle "the circle"
    When I go to the new "Acknowledgement" currencies page
    Then I should be taken to the new "Acknowledgement" currencies page
    When I fill in "Name" with "Flowers"
    And I fill in "config_acknowledge.ack" with "1,2,3"
    And I fill in "config__.max_per_day" with "9"
    And I fill in "config__.max_per_person_per_day" with "5"
    And I press "Create"
    Then I should be taken to the currencies page
    And I should see "Flowers"
    And I bind "Flowers" to "the circle"
    And A user "joe"
    And A user "jane"
    And A user "jill"
    When I make "joe" a "member" of "the circle"
    When I make "jane" a "member" of "the circle"
    When I make "jill" a "member" of "the circle"
    Given "joe" is a "member" of currency "Flowers"
    Given "jane" is a "member" of currency "Flowers"
    Given "jill" is a "member" of currency "Flowers"
    Given I go to the logout page
    Given I log in as "joe"

  Scenario: Joe gives Jane 2 flowers
    When I go to the dashboard page
    And I follow "Acknowledge"
    And I select "2" from "play_ack"
    When I select "Jane User's Flowers member account" from "play_to"
    And I fill in "play_memo" with "the great things you did"
    And I press "Record Play"
    Then I should be taken to the dashboard page
    And I should see /Flowers.*?Given:.*2/ within "#dashboard_flowers_member"
    And I should see /Flowers.*?Received:.*0/ within "#dashboard_flowers_member"
    And I should see /2.*?to.*?Jane.*?User's.*?Flowers.*?member.*?account/ within "#dashboard_flowers_member"
    When I go to the logout page
    And I log in as "jane"
    And I go to the dashboard page
    And I should see /Flowers.*?Given:.*0/ within "#dashboard_flowers_member"
    And I should see /Flowers.*?Received:.*2/ within "#dashboard_flowers_member"

  Scenario: Joe tries to give more flowers than the limits allow
    When I go to the dashboard page
    And I follow "Acknowledge"
    And I select "3" from "play_ack"
    When I select "Jane User's Flowers member account" from "play_to"
    And I fill in "play_memo" with "the great things you did"
    And I press "Record Play"
    Then I should see /Flowers.*?Given:.*3/ within "#dashboard_flowers_member"
    When I follow "Acknowledge"
    And I select "2" from "play_ack"
    And I select "Jane User's Flowers member account" from "play_to"
    And I fill in "play_memo" with "the great things you did"
    And I press "Record Play"
    Then I should see /Flowers.*?Given:.*5/ within "#dashboard_flowers_member"
    When I follow "Acknowledge"
    And I select "3" from "play_ack"
    And I select "Jane User's Flowers member account" from "play_to"
    And I fill in "play_memo" with "the great things you did"
    And I press "Record Play"
    Then I should see "You can only give 5 flowers per person per day"
    When I select "3" from "play_ack"
    And I select "Jill User's Flowers member account" from "play_to"
    And I fill in "play_memo" with "flowers for jill"
    And I press "Record Play"
    Then I should see /Flowers.*?Given:.*8/ within "#dashboard_flowers_member"
    When I follow "Acknowledge"
    And I select "2" from "play_ack"
    And I select "Jill User's Flowers member account" from "play_to"
    And I fill in "play_memo" with "flowers for jill"
    And I press "Record Play"
    Then I should see "You can only give 9 flowers per day"
    
