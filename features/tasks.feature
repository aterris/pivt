Feature: We can list all tasks
  I want to list all of my tasks on the current project

Scenario: list all tasks
  When I successfully run `pivt list`
  Then the stdout should contain "Some new task"