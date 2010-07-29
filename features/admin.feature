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
    
  Scenario: An authenticated admin can create an administrator
    Given I am an admin logged in as "videopaperbuilder@gmail.com"
    When I go to the admin sign up page
    And I fill in the following:
      | Email                 | new_test_admin@velir.com |
      | Password              | funstuff                 |
      | Password confirmation | funstuff                 |
    And I press "Sign up"
    And I go to the admin sign out page
    And I go to the new_test_admin@velir.com's admin confirmation page
    And I am not logged in
    When I go to the admin sign in page
    And I fill in the following:
      | Email    | new_test_admin@velir.com |
      | Password | funstuff                 |
    And I press "Sign in"
    Then I should be on the home page
    And I should see "Signed in successfully"
  
  Scenario: An authenticated admin can create a user
    Given I am an admin logged in as "videopaperbuilder@gmail.com"
    When I go to the user sign up page
    And I fill in the following:
      |Email                 | fun_test_user@velir.com |
      |Password              | funstuff                |
      |Password confirmation | funstuff                |
    And I press "Sign up"
    Then I should be on the user sign in page
    And I should see "You have signed up successfully."
    
  Scenario: An authenticated admin can invite a user
    Given I am an admin logged in as "videopaperbuilder@gmail.com"
    When I go to the user invitation page
    Then I should be on the user invitation page
    And I fill in the following:
      | Email | fun_invite_user@velir.com |
    And I press "Send an invitation"
    Then I should see "An email with instructions about how to set the password has been sent."
      