desc 'clear all fragments from features/output'
task :clear do
  unless ENV.fetch('PROFILE', nil) == 'regression'
    files = Dir.glob("#{Dir.getwd}/features/output/**/*")
    FileUtils.rm_rf(files)
  end
end
