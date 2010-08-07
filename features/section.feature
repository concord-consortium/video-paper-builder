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
  	Then I should see "New video_paper"
  	And I create a new video paper named "Fake Title"
  	Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
  	Then I should have five sections

  Scenario: Normal user edits introduction section
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "New video_paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
    And I follow "Introduction"
    And I follow "Edit Introduction"
    When I fill in "section_content" with "introduction content"
    And I press "Save"
    Then I should see "introduction content"
    And I follow "Introduction"
    And I follow "Edit Introduction"
    And I follow "Cancel"
    Then I should be on Fake Title's video paper page

  Scenario: Normal user edits getting started section
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "New video_paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
    And I follow "Getting Started"
    And I follow "Edit Getting Started"
    When I fill in "section_content" with "getting started content"
    And I press "Save"
    Then I should see "getting started content"
    And I follow "Getting Started"
    And I follow "Edit Getting Started"
    And I follow "Cancel"
    Then I should be on Fake Title's video paper page
    
  Scenario: Normal user edits inquiry section
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "New video_paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
    And I follow "Inquiry"
    And I follow "Edit Inquiry"
    When I fill in "section_content" with "inquiry content"
    And I press "Save"
    Then I should see "inquiry content"
    And I follow "Inquiry"
    And I follow "Edit Inquiry"
    And I follow "Cancel"
    Then I should be on Fake Title's video paper page

  Scenario: Normal user edits wrapping up section
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "New video_paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
    And I follow "Wrapping up"
    And I follow "Edit Wrapping up"
    When I fill in "section_content" with "wrapping up content"
    And I press "Save"
    Then I should see "wrapping up content"
    And I follow "Wrapping up"
    And I follow "Edit Wrapping up"
    And I follow "Cancel"
    Then I should be on Fake Title's video paper page

  Scenario: Normal user edits conclusion section
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "New video_paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
    And I follow "Conclusion"
    And I follow "Edit Conclusion"
    When I fill in "section_content" with "conclusion content"
    And I press "Save"
    Then I should see "conclusion content"
    And I follow "Conclusion"
    And I follow "Edit Conclusion"
    And I follow "Cancel"
    Then I should be on Fake Title's video paper page

  Scenario: Normal user tries to edit section without title parameter
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "New video_paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to edit titleless section on Fake Title
    Then I should see "Introduction"
    When I fill in "section_content" with "introduction content"
    And I press "Save"
    Then I should see "introduction content"
    And I follow "Edit Introduction"
    And I follow "Cancel"
    Then I should be on Fake Title's video paper page

  Scenario: Normal user visits video paper conclusion section
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "New video_paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper conclusion section
    Then I should see "Conclusion"
    And the conclusion tab should be current

  Scenario: Normal user visits video paper introduction section
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "New video_paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper introduction section
    Then I should see "Introduction"
    And the introduction tab should be current
    
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
