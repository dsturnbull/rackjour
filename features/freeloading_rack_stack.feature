Feature: Freeloading rack stack
  A rack consisting of proxy apps is started
  Each app is discovered
  When the app is called
  Then proxy apps are processed on workers

  Scenario: App consisting of all proxy apps
    Given a purely proxy rack
    When the local app is started
    Then each rack app is found on the network
    When I call the local app
    Then each rack app is processed on a worker

  Scenario: App running with mixed local/remote
    Given a mixed local/proxy rack
      And the local rack apps are distributed to workers
    When I call the app
    Then each rack app is processed on a worker

