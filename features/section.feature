Feature:
  In order to fulfill the Video Paper Builder mission
  As an authenticated user
  I want to be able to create a videopaper with five sections

  Background:
    Given the following user records
      | email                       | password | role  |
      | videopaperbuilder@gmail.com | funstuff | admin |
      | test_user@velir.com         | funstuff | user  |
      | random_user@velir.com       | funstuff | user  |  
  	Given I am a user logged in as "test_user@velir.com"

  Scenario: Normal user creates a new video paper containing five sections
  	When I go to the new video paper page
    Then I should see "Create a New Video Paper"
  	And I create a new video paper named "Fake Title"
  	Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
  	Then I should have five sections
  	Then I destroy video paper named "Fake Title"

  Scenario Outline: Normal user edits each section
    When I go to the new video paper page
    Then I should see "Create a New Video Paper"
    And I create a new video paper named "Fake Title"
    When I go to Fake Title's video paper page
    And I follow "<tab_name>"
    And I press "edit_<slug>"
    When I add "<tab_name> content" to "<slug>-content_editor"
    And I press "save-<slug>"
    Then I should see "<tab_name> content"
    Then I destroy video paper named "Fake Title"

 	Examples:
		| tab_name     | slug         |
		| Introduction | introduction |
		| Lesson       | lesson       |
		| Student Work | student_work |
		| Results      | results      |
		| Conclusion  | conclusion   |


  Scenario: Normal user tries to edit section without title parameter
    When I go to the new video paper page
    Then I should see "Create a New Video Paper"
    And I create a new video paper named "Fake Title"
    When I go to Fake Title's video paper page
    Then I should see "Introduction"
    Then I press "edit_introduction"
    When I add "introduction content" to "introduction-content_editor"
    And I press "save-introduction"
    Then I should see "introduction content"
    Then I destroy video paper named "Fake Title"
    

  Scenario: Normal user visits video paper conclusion section
    When I go to the new video paper page
    Then I should see "Create a New Video Paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper conclusion section
    Then I should see "Conclusion"
    And the conclusion tab should be current
    Then I destroy video paper named "Fake Title"
    

  Scenario: Normal user visits video paper introduction section
    When I go to the new video paper page
    Then I should see "Create a New Video Paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper introduction section
    Then I should see "Introduction"
    And the introduction tab should be current
    Then I destroy video paper named "Fake Title"
    
    
  Scenario: Shared user visits Generic Video Paper's page and sees if he/she can edit sections
    When I go to Generic Video Paper's video paper page
    Then I share "Generic Video Paper" with "random_user@velir.com"
    Given I am a user logged in as "random_user@velir.com"
    When I go to Generic Video Paper's video paper page
    Then I should be on Generic Video Paper's video paper page
    Then I should not see "Edit Introduction"
    When I am a user logged in as "test_user@velir.com"
    Then I unshare "Generic Video Paper" with "sharing_user@velir.com"
