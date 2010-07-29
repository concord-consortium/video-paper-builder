Feature:
  In to fulfill the  Video Paper Builder mission
  As an authenticated user
  I want to be able to be invited to the system and log on
  I should not be able to invite or create other users.
  
  Background:
    Given the following user records
      | email                       | password | role  |
      | videopaperbuilder@gmail.com | funstuff | admin |
      
  Scenario: An unauthenticated user to invite another user
    Given I am not logged in
    When I go to the user invitation page
	  Then I should be on the user sign in page
	  And I should see "You neeed to sign in or sign up before continuing"

  Scenario: An authenticated user to invite another user
  	Given I am a user logged in as "fake_user@velir.com"
    When I visit invite_user_path
    Then I should see an error message
