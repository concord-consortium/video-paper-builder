Feature:
  In to fulfill the  Video Paper Builder mission
  As an authenticated user
  I want to be able to manipulate one video per video paper.
  
  Background:
    Given the following user records
      | email                       | password | role  |
      | videopaperbuilder@gmail.com | funstuff | admin |
      | test_user@velir.com         | funstuff | user  |
      
    Given the following video papers
      | title               | user                |
      | Generic Video Paper | test_user@velir.com |
      
  Scenario: Unauthenticated user is unable to create a new video
    Given I am not logged in
    When I go to the Generic Video Paper's new video page
    Then I should be on the user sign in page
    
  Scenario: Authenticated user creates a new video
    Given I am a user logged in as "test_user@velir.com"
    When I go to the Generic Video Paper's new video page
    Then I should see "Generic Video Paper"
    And I should see "Select Video"
    And I should see "Additional Information"
    And I should see "Video Status"
    And I should see "Language:"
    
    