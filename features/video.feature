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
      | title               | user                | status    |
      | Generic Video Paper | test_user@velir.com | published |
      
  Scenario: Unauthenticated user is unable to create a new video
    Given I am not logged in
    When I go to the Generic Video Paper's new video page
    Then I should be on the user sign in page
    
  Scenario: Authenticated user sees new video page
    Given I am a user logged in as "test_user@velir.com"
    When I go to the Generic Video Paper's new video page
    Then I should see "Generic Video Paper"
    And I should see "Select Video"
    And I should see "Additional Information"
    And I should see "Video Status"

  @javascript
  Scenario: Authenticated user creates new video
    Given I am a user logged in as "test_user@velir.com"
    When I go to the Generic Video Paper's new video page
    And I fake upload the test video
    And press "Upload video"
    Then I should be on Generic Video Paper's video paper page

  Scenario: Private video shows as private
    Given I am a user logged in as "test_user@velir.com"
    And a published video paper named "Private Video" with a private video
    And I go to the Private Video's edit video page
    Then the "video_private_true" checkbox should be checked
