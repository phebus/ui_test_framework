desc 'automatically generates documentation using YARD and places it in the doc directory'
task :doc do
  exec('yard doc --plugin cucumber --private --embed-mixins --exclude "vendor" "./features/**/*.rb" "./features/**/*.feature"')
end
