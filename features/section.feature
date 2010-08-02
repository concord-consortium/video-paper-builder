Feature:
  In order to fulfill the Video Paper Builder mission
  As an authenticated user
  I want to be able to create a videopaper with five sections

  Background:
    Given the following user records
      | email                       | password | role  |
      | videopaperbuilder@gmail.com | funstuff | admin |
      | test_user@velir.com         | funstuff | user  |  

  Scenario: Normal user creates a new video paper containing five sections
	Given I am a user logged in as "test_user@velir.com"
	When I go to the new video paper page
	Then I should see "New video_paper"
	And I create a new video paper named "Fake Title"
	Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
	Then I should have five sections
