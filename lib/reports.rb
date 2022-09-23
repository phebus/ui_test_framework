require 'report_builder'
require_relative 'feature_file'
require_relative 'scenario_entry'
require_relative 'command'

class Reports
  # Print statistical information about our tests to STDOUT.
  #
  # Iterate each thing in the features dir. If the thing is a feature
  # file, open it up for parsing, get the count of each scenario and
  # scenario feature.  If its a scenario feature walk down
  # to the examples and count the rows of data.
  #
  # @return [nil]
  #
  Count = Struct.new(:scenarios, :skipped_scenarios, :scenario_outlines, :data_rows, :total, :tag_count)

  def self.test_count(directory, tag_to_count = nil)
    skipped_scenarios         = skipped_scenarios(all_feature_files(directory)).flatten.length
    scenario_count            = all_feature_files(directory).map(&:scenarios).flatten.length
    scenario_outline_count    = all_feature_files(directory).map(&:num_scenario_outlines).inject(0, :+)
    data_row_count            = all_feature_files(directory).map(&:num_data_rows).inject(0, :+)
    tag_count                 = scenarios_with_tag(tag_to_count, all_feature_files(directory)).length unless tag_to_count.nil?
    scenarios                 = scenario_count
    total                     = scenario_count - scenario_outline_count - skipped_scenarios + data_row_count

    Count.new(scenarios, skipped_scenarios, scenario_outline_count, data_row_count, total, tag_count)
  end

  # Print scenarios with tags to STDOUT.
  #
  # @return [nil]
  #
  def self.output_scenarios_with_tags(feature_files = nil)
    return puts 'The TAG parameter is required! (example: TAGS=@myTag)' if ENV['TAGS'].nil? || ENV['TAGS'].to_s.empty?

    feature_files ||= all_feature_files
    ENV['TAGS'].split(',').each do |tag|
      puts "\n\nMATCHING THE TAG #{tag} ..."
      scenarios_with_tag(tag, feature_files).each { |scenario| puts "#{scenario}\n" }
    end
  end

  # Prints scenarios to STDOUT.
  #
  # @return [nil]
  #
  def self.scenarios_to_run(feature_files = nil)
    feature_files ||= all_feature_files
    (all_scenarios(feature_files) - skipped_scenarios(feature_files)).each { |s| puts "#{s}\n" }
  end

  def self.skipped_scenarios(feature_files)
    scenarios_with_tag('@skipped', feature_files)
  end

  # All feature files in a specific directory.
  #
  # @param [String] directory the directory to look for feature files in
  # @return [Set] a set of strings representing features files in `directory`
  #
  def self.all_feature_files(directory = './features')
    sep = directory.end_with?('/') ? '' : '/'
    files = Dir.glob("#{directory}#{sep}**/*.feature")
    files.map { |file| FeatureFile.new(file) }
  end

  # Helper that drops manual tests from a feature list. NOT USED
  #
  # @param [Set] feature_files to process
  # @return [Array] feature_files minus manual tests.
  #
  def self.drop_manual_tests(feature_files)
    feature_files.reject { |path| path.to_s.include? 'manual' }
  end

  # A list of tags from all feature files in {file:./features}.
  #
  # @return [Array] - A list of strings representing cucumber tags
  #
  def self.all_tags
    feature_files = all_feature_files
    feature_files.map(&:all_tags).flatten.uniq
  end

  # A list of scenarios matching a given tag.
  #
  # @param [String] tag_to_match A string representing a cucumber tag to find in all feature files (example: @test_tag)
  # @param [Array] feature_files A list of feature files to search through.
  # @return [Array] of ScenarioEntry objects
  #
  # @note If `feature_files` is unset it will populate using {#all_feature_files('./features/')}
  #
  def self.scenarios_with_tag(tag_to_match, feature_files)
    feature_files.map { |feature|
      feature.scenarios.select { |scenario|
        scenario.tags.include? tag_to_match
      }
    }.flatten
  end

  # A list of features to run.
  #
  # @return [Array] A list of feature files.
  #
  def self.features_to_run
    Dir.glob('**/*.feature').map { |file| File.expand_path(file) }
  end

  # Outputs the specified list to either the stdout stream or the supplied file name (if given).
  #
  # @param [Array] list Array populated with list of items to print.
  # @param [String] output_file Name of output file to write to stdout stream
  # @return [nil]
  #
  def self.output_list(list, output_file = nil)
    output = output_file.nil? ? $stdout : File.open(output_file, 'w')
    list.each { |item| output.puts(item) }
  ensure
    output.close unless output_file.nil?
  end

  # All the scenarios in a given feature file.
  #
  # @param [Object] feature_file A file object representing the feature file to retrieve scenarios from
  # @return [Array] A list of scenarios in the form:
  #   \"relative file path: line number:\n\tScenario\"
  #
  def self.all_scenarios_in_feature_file(feature_file)
    FeatureFile.new(feature_file).scenarios
  end

  # All the scenarios in a given list of feature files
  #
  # @param [Object] feature_files A file object representing the feature file to retrieve scenarios from.
  #                               Defaults to all automated.
  # @return [Set] A list of ScenarioEntry structures.
  #
  def self.all_scenarios(feature_files)
    feature_files.map(&:scenarios).flatten
  end

  def self.build_report
    ::ReportBuilder.configure do |config|
      config.json_path        = 'features/output'
      config.report_path      = 'features/output/test_report'
      config.report_types     = %i{json html}
      config.report_tabs      = %i{overview features scenarios errors}
      config.report_title     = 'Test Results'
      config.compress_images  = true
    end
    ::ReportBuilder.build_report
  end
end
