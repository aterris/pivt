Feature: We can list all tasks
  I want to list all of my tasks on the current project

Scenario: list all tasks
  When I successfully run `pivt -u atterris@gmail.com -p pwd -n "Andrew Terris" --project=5 list`
  Then the stdout should contain "0. Facebook share modal popping up under the details box"