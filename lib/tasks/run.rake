desc 'run tests (DEFAULT)'
task run: :clear do
  Command.run_scenarios
  Reports.build_report
end
