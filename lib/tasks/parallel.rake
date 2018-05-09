desc 'run tests in parallel'
task parallel: :clear do
  Command.run_parallel
  Reports.build_report
end
