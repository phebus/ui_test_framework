@examples
  Feature: An example feature file

    @search
    Scenario: Go to Google and search
      Given I am on the Google search page
      When I search for "test"
      Then I will receive results
