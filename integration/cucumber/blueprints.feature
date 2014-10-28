Feature: blueprints
  In order to use blueprints with cucumber
  As a developer
  I should be able build blueprints with correct data

  Scenario: build cherry
    Given I have apple
    Then apple should be available
    And apple should equal "apple"

  Scenario: no cherry
    Then apple should NOT be available

  Scenario: global cherry prebuild
    When global_cherry should equal "cherry"
    Then I change global_cherry

  Scenario: global cherry another prebuild
    When global_cherry should equal "cherry"
    Then I change global_cherry
