Feature:
  In to fulfill the  Video Paper Builder mission
  As an authenticated user
  I want to be able to share my video papers with other users, and view shared video papers.
  
  Background:
    Given the following user records
      | email                       | password | role  |
      | videopaperbuilder@gmail.com | funstuff | admin |
      | test_user@velir.com         | funstuff | user  |
      | sharing_user@velir.com      | funstuff | user  |
      
    Given the following video papers with videos
      | title               | user                | status    |
      | Generic Video Paper | test_user@velir.com | published |
      
  Scenario: Non-owner& non-shared user of 'Generic Video Paper' attempts to access it
    Given I am a user logged in as "sharing_user@velir.com"
    When I go to Generic Video Paper's video paper page
    Then I should be on the new video paper page

  @javascript
  Scenario: Owner of 'Generic Video Paper' shares it to 'sharing_user@velir.com'
    Given I am a user logged in as "test_user@velir.com"
    When I go to my video papers page
    Then I follow "Sharing" within "#generic-video-paper"
    Then I should see "Sharing Settings for Generic Video Paper"
    And I fill in the following:
      | shared_paper_user_id | sharing_user@velir.com  |
      | shared_paper_notes | I like beets |
    Then I press "Share"
    Then I should see "Shared With:"
    And I should see "sharing_user@velir.com"

  Scenario: A user can see the list of papers shared with them
    Given I am a user logged in as "sharing_user@velir.com"
    And the video paper "Generic Video Paper" is shared with me
    When I go to my shared papers page
    Then I should see "Generic Video Paper"

  Scenario: Non-owner & shared user of 'Generic Video Paper' attempts to access it
    Given I am a user logged in as "sharing_user@velir.com"
    And the video paper "Generic Video Paper" is shared with me
    When I go to Generic Video Paper's video paper page
    Then I should be on Generic Video Paper's video paper page

  @javascript
  Scenario: Owner removes the shared user of 'Generic Video Paper'
    Given I am a user logged in as "test_user@velir.com"
    And my video paper "Generic Video Paper" is shared with "test_user@velir.com"
    When I go to my video papers page
    When I follow "Sharing" within "#generic-video-paper"
    Then I should see "Shared With"
    Then I follow "unshare" within "#user-shared"
    And I should not see "test_user@velir.com" within "#user-shared"
    
  Scenario: Now unshared user tries to access 'Generic Video Paper'
    Given I am a user logged in as "sharing_user@velir.com"
    When I go to Generic Video Paper's sharing page
    Then I should be on the new video paper page
    
  Scenario: Owner attempts to share 'Generic Video Paper' with a non-user
    Given I am a user logged in as "test_user@velir.com"
    When I go to Generic Video Paper's sharing page
    And I fill in the following:
      | shared_paper_user_id | thisisntanemail@velir.com |
    Then I press "Share"
  
