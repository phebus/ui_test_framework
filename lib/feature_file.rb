class FeatureFile < File
  attr_accessor :lines, :tags

  def initialize(file)
    super(file)
    @lines          = cleaned_lines
    @feature_tags   = feature_tags
    @scenarios      = scenarios
    @tags           = all_tags
  end

  def feature_tags
    lines.first.split.first.start_with?('@') ? lines.first.split : []
  end

  def cleaned_lines
    readlines.map { |l| l.to_s.chars.select(&:valid_encoding?).join.strip }
  end

  def scenarios
    lines.map.with_index do |line, index|
      next unless line.start_with?('Scenario')

      name = line.split(':')[1].strip
      ScenarioEntry.new(path_line: "#{path}:#{index + 1}", name:, feature: self, tags: @feature_tags)
    end.compact
  end

  def num_examples
    lines.select { |line| line.start_with? 'Examples:' }.length
  end

  def num_scenario_outlines
    @scenarios.select(&:outline?).length
  end

  def num_data_rows
    @scenarios.map(&:example_rows).flatten.size
  end

  def all_tags
    (@feature_tags + @scenarios.map(&:tags)).flatten.uniq
  end
end
