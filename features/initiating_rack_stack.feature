Feature: Initiating rack stack
  A rack is started
  As workers are discovered
  Each app is deployed to each worker

  Scenario: App running without workers
    Given a rack
      And the rack is started
    When I call the app
    Then each app is processed locally

  Scenario: App running and a worker added
    Given a rack
      And the rack is started
      And a worker is added
    Then all apps are distributed to the worker
    When I call the app
    Then each app is processed on the worker

  Scenario: App running with worker, additional worker added
    Given a rack
      And the rack is started
      And a worker is added
    Then all apps are distributed to the worker
    Given a worker is added
    Then all apps are distributed to the worker
    When I call the app
    Then each app is processed on one of the workers
