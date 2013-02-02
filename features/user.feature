Feature:
  In to fulfill the  Video Paper Builder mission
  As an authenticated user
  I want to be able to be invited to the system and log on
  I should not be able to invite or create other users.
  
  Background:
    Given the following user records
      | email                       | password | role  |
      | videopaperbuilder@gmail.com | funstuff | admin |
      
  Scenario: An unauthenticated user attempts to invite another user
    Given I am not logged in
    When I go to the user invitation page
	  Then I should be on the admin sign in page
	  And I should see "You need to sign in or sign up before continuing"

  Scenario: An unauthenticated user tries to create another user
    Given I am not logged in
    When I go to the user sign up page
    Then I should be on the home page
    And I should see "You must be invited to use Video Paper Builder"
    
  Scenario: A user can follow an invitation email
    Given the administrator "videopaperbuilder@gmail.com" invites a user "super_fun_time@velir.com"
    Given I am not logged in
    When I go to the super_fun_time@velir.com's user invitation page
    Then I fill in the following within "#body_container":
      | Password | funstuff |
      | Password confirmation | funstuff |
    And I press "Submit"
    Then I should be on the new video paper page
    And I should see "Your password was set successfully. You are now signed in."
