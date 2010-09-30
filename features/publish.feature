Feature:
  In to fulfill the  Video Paper Builder mission
  As an owner of a video paper
  I want to be able to set the publish and unpublish video papers.
  
  Background:
    Given the following user records
      | email                       | password | role  |
      | videopaperbuilder@gmail.com | funstuff | admin |
      | test_user@velir.com         | funstuff | user  |
      | sharing_user@velir.com      | funstuff | user  |
      
    Given the following video papers
      | title               | user                |
      | Generic Video Paper | test_user@velir.com |
      | Unpublished Paper   | test_user@velir.com |
      
  Scenario: Shared user of "Unpublished Paper" shouldn't be able to view an unpublished paper
    Given I am a user logged in as "test_user@velir.com"
    When I go to Unpublished Paper's video paper page
    Then I share "Unpublished Paper" with "sharing_user@velir.com"
    Given I am a user logged in as "sharing_user@velir.com"
    When I go to Unpublished Paper's video paper page
    Then I should be on the my shared papers page
    When I am a user logged in as "test_user@velir.com"
    Then I unshare "Unpublished Paper" with "sharing_user@velir.com"    
    
  Scenario: Shared user of "Generic Video Paper" should be able to view published paper
    Given I am a user logged in as "test_user@velir.com"
    When I go to Generic Video Paper's video paper page
    Then I share "Generic Video Paper" with "sharing_user@velir.com"
    Given I am a user logged in as "sharing_user@velir.com"
    When I go to Generic Video Paper's video paper page
    Then I should be on Generic Video Paper's video paper page
    When I am a user logged in as "test_user@velir.com"
    Then I unshare "Generic Video Paper" with "sharing_user@velir.com"
    
  Scenario: Publishing "Unpublished Paper" makes it visible to the shared user
    Given I am a user logged in as "test_user@velir.com"
    When I go to Unpublished Paper's video paper page
    Then I share "Unpublished Paper" with "sharing_user@velir.com"
    When I go to my video papers page    
    When I follow "Publish" within "#unpublished-paper"
    Given I am a user logged in as "sharing_user@velir.com"
    When I go to Unpublished Paper's video paper page
    Then I should be on Unpublished Paper's video paper page
    When I am a user logged in as "test_user@velir.com"
    Then I unshare "Unpublished Paper" with "sharing_user@velir.com"
    
  Scenario: Unpublishing "Unpublished Paper" then makes it invisible again
    Given I am a user logged in as "test_user@velir.com"
    When I go to Unpublished Paper's video paper page
    Then I share "Unpublished Paper" with "sharing_user@velir.com"
    When I go to my video papers page    
    When I follow "Unpublish" within "#unpublished-paper"
    Given I am a user logged in as "sharing_user@velir.com"
    When I go to Unpublished Paper's video paper page
    Then I should be on the my shared papers page
    When I am a user logged in as "test_user@velir.com"
    Then I unshare "Unpublished Paper" with "sharing_user@velir.com"    
    