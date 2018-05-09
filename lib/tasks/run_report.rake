desc 'run tests with report building'
task run_report: :clear do
  Command.run_scenarios
  Reports.build_report
end
