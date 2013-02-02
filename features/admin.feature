Feature:
  In order to fulfill the Video Paper Builder mission
  As an authenticated administrator
  I want to be able to invite and create new administrative users
  
  Background:
    Given the following user records
      | email                       | password | role  |
      | videopaperbuilder@gmail.com | funstuff | admin |
      
  Scenario: An unauthenticated admin tries to invite an administrator
    Given I am not logged in
    When I go to the admin invitation page
    Then I should not be able to invite an admin
    
  Scenario: An unauthenticated admin tries to create a new administrator
    Given I am not logged in
    When I go to the admin sign up page
    Then I should not be able to create an administrator
    
  Scenario: An authenticated admin can invite an administrator
    Given I am an admin logged in as "videopaperbuilder@gmail.com"
    When I go to the admin invitation page
    Then I should be able to invite an administrator
    
  Scenario: An authenticated admin can invite a user
    Given I am an admin logged in as "videopaperbuilder@gmail.com"
    When I go to the user invitation page
    Then I should be on the user invitation page
    And I fill in the following within "#body_container": 
      | First name | John                      |
      | Last name  | Doe                       |
      | Email      | fun_invite_user@velir.com |
    And I press "Invite"
    Then I should see "An email with instructions about how to set the password has been sent."
      