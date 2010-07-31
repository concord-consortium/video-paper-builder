Feature:
  In order to fulfill the Video Paper Builder mission
  As an authenticated user
  I want to be able to create a videopaper with five sections

  Background:
    Given the following user records
      | email                       | password | role  |
      | videopaperbuilder@gmail.com | funstuff | admin |
      | test_user@velir.com         | funstuff | user  |  

  Scenario: Unauthenticated user attempts to access a video paper section
    Given I am not logged in
    When I go to the video paper section intro page
	Then i should stop here
    Then I should be on the user sign in page
    And I should see "You need to sign in or sign up before continuing"
