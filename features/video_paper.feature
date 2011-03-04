Feature:
  In to fulfill the  Video Paper Builder mission
  As an authenticated user
  I want to be able to create, update, edit, and destroy video papers.
  As an admin I am unable to create new video papers.
  
  Background:
    Given the following user records
      | email                       | password | role  |
      | videopaperbuilder@gmail.com | funstuff | admin |
      | test_user@velir.com         | funstuff | user  |
      | sharing_user@velir.com      | funstuff | user  |
    
    Given the following video papers with videos
      | title                    | user                | status    |
      | Generic Video Paper      | test_user@velir.com | published |
      | Less Generic Video Paper | test_user@velir.com | published |
      
    Given the following videos
      | video paper         |
      | Generic Video Paper |
  
  Scenario: Unauthenticated user attempts to access a video paper
    Given I am not logged in
    When I go to the new video paper page
    Then I should be on the user sign in page
    And I should see "You need to sign in or sign up before continuing"
    
  Scenario: Admin user attempts to access a video paper
    Given I am an admin logged in as "videopaperbuilder@gmail.com"
    When I go to the video paper page
    Then I should be on the video paper page
    
  Scenario: Admin attempts to create a new video paper
    Given I am an admin logged in as "videopaperbuilder@gmail.com"
    When I go to the new video paper page
    Then I should be on the user sign in page
    
  Scenario: Normal user attempts to access a video paper
    When I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "Create a New Video Paper"
    
  Scenario: Normal user creates a video paper
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "Create a New Video Paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper 'Fake Title' was successfully created."
    Then I destroy video paper named "Fake Title"
  
  Scenario: Normal user edits video paper
    Given I am a user logged in as "test_user@velir.com"
    Given a video paper named "Fake Edit Title"
    When I edit the video paper title named "Fake Edit Title"
    Then I should see "VideoPaper was successfully updated."
    Then I destroy video paper named "Updated Fake Edit Title"
    
  Scenario: Normal user destroys video paper
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "Create a New Video Paper"
    And I create a new video paper named "Fake Delete Title"
    When I go to the my_video_papers page
    And I pre-confirm
    And I follow "Remove"
    Then I should see "VideoPaper was successfully destroyed."
    
  Scenario: 'test_user@velir.com' views Generic Video Paper
    Given I am a user logged in as "test_user@velir.com"
    When I go to Generic Video Paper's video paper page
    Then I should see "Generic Video Paper"
    And I should see "Produced by Robert Bobberson"
    And I should see an embedded video
    
  Scenario: 'test_user@velir.com' views Less Generic Video Paper
    Given I am a user logged in as "test_user@velir.com"
    When I go to Less Generic Video Paper's video paper page
    Then I should see "Less Generic Video Paper"
    And I should see "Produced by Robert Bobberson"
    And I should see an embedded video    
    
  Scenario: 'sharing_user@velir.com' views Generic Video Paper
    Given I am a user logged in as "test_user@velir.com"
    When I share "Generic Video Paper" with "sharing_user@velir.com"
    When I am a user logged in as "sharing_user@velir.com"
    And I go to Generic Video Paper's video paper page  
    Then I should see "Generic Video Paper"
    Then I should see "Generic Video Paper"
    And I should see "Produced by Robert Bobberson"
    And I should see an embedded video
    When I am a user logged in as "test_user@velir.com"
    Then I unshare "Generic Video Paper" with "sharing_user@velir.com"
    
  Scenario: 'sharing_user@velir.com' views Less Generic Video Paper
    Given I am a user logged in as "test_user@velir.com"
    And a published video paper named "Private Video" with a private video
    When I share "Private Video" with "sharing_user@velir.com"
    When I am a user logged in as "sharing_user@velir.com"
    And I go to Private Video's video paper page
    Then I should be on Private Video's video paper page
    Then I should see "Private Video"
    And I should see "Produced by Robert Bobberson"
    And I should not see an embedded video
    