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
      
    Given the following video papers
      | title               | user                |
      | Generic Video Paper | test_user@velir.com |
      
  Scenario: Non-owner& non-shared user of 'Generic Video Paper' attempts to access it
    Given I am a user logged in as "sharing_user@velir.com"
    When I go to Generic Video Paper's video paper page
    Then I should be on the home page

  Scenario: Owner of 'Generic Video Paper' shares it to 'sharing_user@velir.com'
    Given I am a user logged in as "test_user@velir.com"
    When I go to Generic Video Paper's sharing page
    Then I should see "Sharing Settings for Generic Video Paper"
    And I fill in the following:
      | Share With: | sharing_user@velir.com  |
      | Add a note (optional): | I like beets |
    Then I press "Share"
    And I should be on the video paper page
    When I go to Generic Video Paper's sharing page
    Then I should see "Shared With:"
    And I should see "sharing_user@velir.com"
    And I should see "Unshare"
    
  Scenario: Non-owner & shared user of 'Generic Video Paper' attempts to access it
    Given I am a user logged in as "sharing_user@velir.com"
    When I go to Generic Video Paper's video paper page
    Then I should be on Generic Video Paper's video paper page
    
  Scenario: Owner removes the shared user of 'Generic Video Paper'
    Given I am a user logged in as "test_user@velir.com"
    When I go to Generic Video Paper's sharing page
    When I follow "Unshare"
    Then I should be on Generic Video Paper's sharing page
    And I should not see "sharing_user@velir.com"
    And I should see "Removed User from shared list."
    
  Scenario: Now unshared user tries to access 'Generic Video Paper'
    Given I am a user logged in as "sharing_user@velir.com"
    When I go to Generic Video Paper's sharing page
    Then I should be on the home page