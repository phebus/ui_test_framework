class Command
  # Run all scenarios of our scenarios.
  #
  # @return [nil]
  #
  def self.run_scenarios
    raise "TAGS, AND_TAGS, or FEATURE must be set" unless !!ENV['TAGS'] || !!ENV['FEATURE'] || !!ENV['AND_TAGS']

    system "cucumber -c #{profile_cmd} #{tag_cmd} #{and_tag_cmd} #{feature_cmd}"
  end

  def self.run_parallel
    system "parallel_cucumber #{num_procs} features/ -o '#{profile_cmd} #{tag_cmd} #{and_tag_cmd}'"
  end

  # Parses the TAGS= expressions from the ARGV so we can massage it to match the Cucumber --tags syntax.
  # This allows us to use logical and/or when specifying tags.
  # @see https://github.com/cucumber/cucumber/wiki/Tags
  #
  # @return [String] A massaged TAGS= expression that cucumber can work with.
  def self.tag_cmd
    ENV.fetch('TAGS', '').empty? ? nil : "--tags #{ENV.fetch('TAGS')}"
  end

  def self.and_tag_cmd
    return nil if ENV.fetch('AND_TAGS', '').empty?

    ENV.fetch('AND_TAGS').split(',').map { |tag| "--tags #{tag} " }.join
  end

  def self.feature_cmd
    ENV.fetch('FEATURE', '').empty? ? 'features' : "#{ENV.fetch('FEATURE')} --require features"
  end

  def self.profile_cmd
    ENV.fetch('PROFILE', '').empty? ? nil : "-p #{ENV.fetch('PROFILE')}"
  end

  def self.dir_cmd
    ENV.fetch('DIR', '').empty? ? 'features' : ENV.fetch('DIR')
  end

  def self.num_procs
    "-n #{ENV.fetch('NUM_PROCS', '2')}"
  end
end
