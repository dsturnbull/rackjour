Feature: Rackjour Worker

  Scenario: Rackjour workers respond to bonjour probes
    Given I have a rackjour worker listening
    Then the worker is discoverable

  Scenario: Rackjour workers allow Rackjour masters to deploy rack apps to them
    Given I have a rackjour worker listening
    And the worker has been set up
    When the worker receives a job request
    Then the job is deployed
      And the job can be called

  Scenario: Rackjour workers provide load balancing hints to masters
    Given I have a rackjour worker listening
      And the worker has a deployed job
    When the worker receives a status command
    Then the worker replies with a summary of job load
