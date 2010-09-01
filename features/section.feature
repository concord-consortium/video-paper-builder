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

  Scenario: Normal user creates a new video paper containing five sections
  	Given I am a user logged in as "test_user@velir.com"
  	When I go to the new video paper page
    Then I should see "Create a New Video Paper"
  	And I create a new video paper named "Fake Title"
  	Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
  	Then I should have five sections
  	Then I destroy video paper named "Fake Title"

  Scenario: Normal user edits introduction section
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "Create a New Video Paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
    And I follow "Introduction"
    And I press "edit_introduction"
    When I add "introduction content woo" to "introduction-content_editor"
    And I press "save-introduction"
    Then I should see "introduction content"
    Then I destroy video paper named "Fake Title"
    

  Scenario: Normal user edits getting started section
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "Create a New Video Paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
    And I follow "Getting Started"
    And I press "edit_getting_started"
    When I add "getting started content" to "getting_started-content_editor"
    And I press "save-getting_started"
    Then I should see "getting started content"
    Then I destroy video paper named "Fake Title"
    
    
  Scenario: Normal user edits inquiry section
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "Create a New Video Paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
    And I follow "Inquiry"
    And I press "edit_inquiry"
    When I add "inquiry content" to "inquiry-content_editor"
    And I press "save-inquiry"
    Then I should see "inquiry content"
    Then I destroy video paper named "Fake Title"
    

  Scenario: Normal user edits wrapping up section
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "Create a New Video Paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
    And I follow "Wrapping up"
    And I press "edit_wrapping_up"
    When I add "wrapping up content" to "wrapping_up-content_editor"
    And I press "save-wrapping_up"
    Then I should see "wrapping up content"
    Then I destroy video paper named "Fake Title"
    

  Scenario: Normal user edits conclusion section
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "Create a New Video Paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
    And I follow "Conclusion"
    And I press "edit_conclusion"
    When I add "conclusion content" to "conclusion-content_editor"
    And I press "save-conclusion"
    Then I should see "conclusion content"
    Then I destroy video paper named "Fake Title"
    

  Scenario: Normal user tries to edit section without title parameter
    Given I am a user logged in as "test_user@velir.com"
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
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "Create a New Video Paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper conclusion section
    Then I should see "Conclusion"
    And the conclusion tab should be current
    Then I destroy video paper named "Fake Title"
    

  Scenario: Normal user visits video paper introduction section
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "Create a New Video Paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper introduction section
    Then I should see "Introduction"
    And the introduction tab should be current
    Then I destroy video paper named "Fake Title"
    
    
  Scenario: Shared user visits Generic Video Paper's page and sees if he/she can edit sections
    Given I am a user logged in as "test_user@velir.com"
    When I go to Generic Video Paper's video paper page
    Then I share "Generic Video Paper" with "random_user@velir.com"
    Given I am a user logged in as "random_user@velir.com"
    When I go to Generic Video Paper's video paper page
    Then I should be on Generic Video Paper's video paper page
    Then I should not see "Edit Introduction"
    When I am a user logged in as "test_user@velir.com"
    Then I unshare "Generic Video Paper" with "sharing_user@velir.com"
