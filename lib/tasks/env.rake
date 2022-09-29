desc 'dump the ruby config'
task :env do
  puts <<~ENV

         === RbConfig::CONFIG ===

         #{YAML.dump(RbConfig::CONFIG)}

         === $LOAD_PATH ===

         #{$:}

  ENV
end
