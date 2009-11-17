Feature: Freeloading rack stack
  A rack app consisting of some number of Rackjour::Remote apps is started
  When the app is called
  Then requests are distributed

  Scenario: App running with all remote
    Given a purely remote rack app
      And the rack app is started
    When I call the app
    Then requests are remote

  Scenario: App running with mixed local/remote
    Given a mixed local/remote rack app
      And the rack app is started
      And a worker is added
    Then the local racks are distributed to workers
    When I call the app
    Then requests are remote

  Scenario: App running with broken remote
    Given a purely remote rack app
      And the rack app is started
      And a worker is added
    Then the local racks are distributed to workers
      And specific app is broken
    When I call the app
    Then specific app is healed
      And requests are remote

