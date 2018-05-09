class Command
  # Run all scenarios of our scenarios.
  #
  # @return [nil]
  #
  def self.run_scenarios
    system "cucumber -c #{profile_cmd} #{tag_cmd} #{and_tag_cmd} #{feature_cmd}"
  end

  def self.run_parallel
    system "parallel_cucumber #{num_procs} features/ -o '#{tag_cmd} #{and_tag_cmd}'"
  end

  # Parses the TAGS= expressions from the ARGV so we can massage it to match the Cucumber --tags syntax.
  # This allows us to use logical and/or when specifying tags.
  # @see https://github.com/cucumber/cucumber/wiki/Tags
  #
  # @return [String] A massaged TAGS= expression that cucumber can work with.
  def self.tag_cmd
    ENV['TAGS'].to_s.empty? ? nil : "--tags #{ENV['TAGS']}"
  end

  def self.and_tag_cmd
    return nil if ENV['AND_TAGS'].to_s.empty?
    ENV['AND_TAGS'].split(',').map { |tag| "--tags #{tag} " }.join
  end

  def self.feature_cmd
    ENV['FEATURE'].to_s.empty? ? 'features' : ENV['FEATURE'] + ' --require features'
  end

  def self.profile_cmd
    ENV['PROFILE'].to_s.empty? ? nil : "-p #{ENV['PROFILE']}"
  end

  def self.dir_cmd
    ENV['DIR'].to_s.empty? ? 'features' : ENV['DIR']
  end

  def self.num_procs
    "-n #{ENV['NUM_PROCS']}" || nil
  end
end
