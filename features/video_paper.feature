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
    Then I should see "New video_paper"
    
  Scenario: Normal user creates a video paper
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "New video_paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
  
  Scenario: Normal user edits video paper
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "New video_paper"
    And I create a new video paper named "Fake Title"
    When I edit the video paper title named "Fake Title"
    Then I should see "VideoPaper was successfully updated."
    
  Scenario: Normal user destroys video paper
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then show me the page
    Then I should see "New video_paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
    And I follow "Destroy"
    Then I should see "VideoPaper was successfully destroyed."
    
    