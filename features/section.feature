Feature:
  In order to fulfill the Video Paper Builder mission
  As an authenticated user
  I want to be able to create a videopaper with five sections

  Background:
    Given the following user records
      | email                       | password | role  |
      | videopaperbuilder@gmail.com | funstuff | admin |
      | test_user@velir.com         | funstuff | user  |  

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
    And I follow "Edit Introduction"
    Then I should see "Introduction"
    When I fill in "section_content" with "introduction content"
    And I press "Save"
    Then I should see "introduction content"
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
    And I follow "Edit Getting Started"
    Then I should see "Getting Started"
    When I fill in "section_content" with "getting started content"
    And I press "Save"
    Then I should see "getting started content"
    And I follow "Edit Introduction"
    And I follow "Cancel"
    Then I should be on Fake Title's video paper page
    
  Scenario: Normal user edits inquiry section
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "New video_paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
    And I follow "Edit Inquiry"
    Then I should see "Inquiry"
    When I fill in "section_content" with "inquiry content"
    And I press "Save"
    Then I should see "inquiry content"
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
    Then I should see "Wrapping up"
    When I fill in "section_content" with "wrapping up content"
    And I press "Save"
    Then I should see "wrapping up content"
    And I follow "Edit Wrapping up"
    And I follow "Cancel"
    Then I should be on Fake Title's video paper page

  Scenario: Normal user edits conclusion up section
    Given I am a user logged in as "test_user@velir.com"
    When I go to the new video paper page
    Then I should see "New video_paper"
    And I create a new video paper named "Fake Title"
    Then I should see "VideoPaper was successfully created."
    When I go to Fake Title's video paper page
    And I follow "Conclusion"
    Then I should see "Conclusion"
    When I fill in "section_content" with "conclusion content"
    And I press "Save"
    Then I should see "conclusion content"
    And I follow "Edit Conclusion"
    And I follow "Cancel"
    Then I should be on Fake Title's video paper page
