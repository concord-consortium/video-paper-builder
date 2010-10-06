Feature:
  In to fulfill the  Video Paper Builder mission
  As an owner of a video paper
  I want to be able to set the start and stop times for the video during an individual section.
  
  Background:
    Given the following user records
      | email                       | password | role  |
      | videopaperbuilder@gmail.com | funstuff | admin |
      | test_user@velir.com         | funstuff | user  |
      | sharing_user@velir.com      | funstuff | user  |
      
    Given the following video papers
      | title               | user                |
      | Generic Video Paper | test_user@velir.com |
      
  Scenario: As a shared user, I should not be able to access the timing actions.
    Given I am a user logged in as "test_user@velir.com"
    When I go to Generic Video Paper's video paper page
    Then I share "Generic Video Paper" with "sharing_user@velir.com"
    Given I am a user logged in as "sharing_user@velir.com"
    When I go to Generic Video Paper's video paper edit timing page
    Then I should be on the new video paper page
    Given I am a user logged in as "test_user@velir.com"
    Then I unshare "Generic Video Paper" with "sharing_user@velir.com"  
    
  Scenario: As the video paper owner, I should be able to access the timing actions.
    Given I am a user logged in as "test_user@velir.com"
    When I go to Generic Video Paper's video paper page
    When I press "edit_introduction"
    And I perform javascript confirmation box magic    
    And I follow "Edit Timing"
    And I should see "Start Time (HH:MM:SS)"
    And I should see "Stop Time (HH:MM:SS)"
    
  Scenario: As the video paper owner, I should be able to set the timings
    Given I am a user logged in as "test_user@velir.com"
    When I go to Generic Video Paper's video paper page
    When I press "edit_introduction"
    And I perform javascript confirmation box magic     
    And I follow "Edit Timing"
    And I fill in "Start Time (HH:MM:SS)" with "5"
    And I fill in "Stop Time (HH:MM:SS)" with "8"
    And I press "Save timings"
    Then I should be on Generic Video Paper's video paper page
    And I should see "Timing successfully updated."
    
  Scenario: As the video paper owner, I should not be able to set silly timings
    Given I am a user logged in as "test_user@velir.com"
    When I go to Generic Video Paper's video paper page
    When I press "edit_introduction"
    And I perform javascript confirmation box magic     
    And I follow "Edit Timing"
    And I fill in "Start Time (HH:MM:SS)" with "waffles"
    And I fill in "Stop Time (HH:MM:SS)" with "peanuts"
    And I press "Save timings"
    Then I should be on Generic Video Paper's video paper page
    And I should see "Invalid time!"
  