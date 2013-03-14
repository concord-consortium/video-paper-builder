Feature:
  In order to fulfill the Video Paper Builder mission
  As an authenticated administrator
  I want to be able to manage existing users
  
  Background:
    Given the following user records
      | email                       | password | role  | confirmed |
      | videopaperbuilder@gmail.com | funstuff | admin | yes       |
      | user@example.com            | funstuff | user  | yes       |
      | user2@example.com           | funstuff | user  | no        |
      
  Scenario: An admin can see a list of users
    Given I am an admin logged in as "videopaperbuilder@gmail.com"
    When I go to the admin console page
    Then I should see a list of admin and regular users
    
  Scenario: An admin can see which users have not accepted their invitations
    Given I am an admin logged in as "videopaperbuilder@gmail.com"
    When I go to the admin console page
    Then I should see "Accept Invitation"
    
  Scenario: An admin can accept the invitation for a user because the user didn't get the email
    Given I am an admin logged in as "videopaperbuilder@gmail.com"
    When I go to the admin console page
    And I follow "Accept Invitation"
    Then I fill in the following within "#body_container":
      | Password | funstuff |
      | Password confirmation | funstuff |
    And I press "Submit"
    Then I should be on the admin console page
    And I should not see "Accept Invitation"

  Scenario: An admin can change a users email
    Given I am an admin logged in as "videopaperbuilder@gmail.com"
    When I go to the admin console page
    And I follow "Edit"
    Then I fill in "Email" with "user+modified@example.com" within "#inner_container"
    And I press "Update User"
    Then I should be on the admin console page
    And I should see "user+modified@example.com"
