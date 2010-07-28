Feature:
  In the VideoPaperBuilder mission
  As an authenticated user
  I want to be able to login to the application
  
  Background:
    Given the following user records
      | email                | password | role  |
      | fake_user@velir.com  | funstuff | user  |
      
  Scenario: An unauthenticated user to invite another user
    Given I am not logged in
    When I visit invite_user_path
	Then I should see an error message

  Scenario: An authenticated user to invite another user
  	Given I am a user logged in as "fake_user@velir.com"
    When I visit invite_user_path
	Then I should see an error message
