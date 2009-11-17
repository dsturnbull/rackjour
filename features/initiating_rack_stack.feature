Feature: Initiating rack stack
  A rack app consisting of some number of apps is started
  As workers are discovered
  Each rack is deployed to each worker unless the rack is already deployed

  Scenario: App running without workers
    Given a rack app
      And the rack app is started
    When I call the app
    Then requests are local

  Scenario: App running and worker added
    Given a rack app
      And the rack app is started
      And a worker is added
    Then all apps are distributed to the worker
    When I call the app
    Then requests are remote

  Scenario: App running with worker, additional worker added
    Given a rack app
      And the rack app is started
    Then all apps are distributed to the worker
      And a worker is added
    Then all apps are distributed to the worker
    When I call the app
    Then requests are remote

  Scenario: App running with worker, additional app added
    Given a rack app
      And the rack app is started
    Then all apps are distributed to the worker
    When I call the app
    Then requests are remote
    When I add a new app
    Then the new services are distributed to the worker

