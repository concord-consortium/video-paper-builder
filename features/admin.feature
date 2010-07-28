Feature:
  In the VideoPaperBuilder mission
  As an authenticated administrator
  I want to be able to invite admins
  
  Background:
    Given the following user records
      | email                | password | role  |
      | fake_admin@velir.com | funstuff | admin |
      
  Scenario: An unauthenticated admin tries to invite an administrator
    Given I am not logged in
    When I visit admins_invitation_path
    Then I should not be able to invite administrator
    
  Scenario: An unauthenticated admin tries to create a new administrator
    Given I am not logged in
    When I visit admins_new_path
    Then I should not be able to create an administrator
    
  Scenario: An authenticated admin can invite an administrator
    Given I am an admin logged in as "fake_admin@velir.com"
    When I visit admins_invitation_path
    Then I should be able to invite an administrator
    
  Scenario: An authenticated admin can create an administrator
    Given I am an admin logged in as "fake_admin@velir.com"
    When I visit admins_new_path
    Then I should be able to create an administrator