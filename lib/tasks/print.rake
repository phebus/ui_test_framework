namespace :print do
  desc 'prints all the tags currently in all feature files'
  task :all_tags do
    tags = Reports.all_tags
    printf "%-50s %s\n", 'Tag', 'Number of Scenarios'
    printf "%-50s %s\n", '---', '-------------------'
    tags.sort.each do |tag|
      printf "%-50s %s\n", tag, Reports.scenarios_with_tag(tag, Reports.all_feature_files).length
    end
  end

  desc 'prints all the scenarios matching the given tag (required: TAGS=)'
  task :scenarios_with_tags do
    Reports.output_scenarios_with_tags
  end

  desc 'prints the full file name of all the feature files that have at least one non-skipped scenario'
  task :features_to_run do
    output_file = ENV['OUTPUT'] unless ENV['OUTPUT'].to_s.empty?
    feature_list = Reports.features_to_run
    Reports.output_list(feature_list, output_file)
  end

  desc "prints every scenario from every feature file in the features directory (doesn't include @skipped)"
  task :scenarios_to_run do
    Reports.scenarios_to_run
  end

  desc 'prints the number of all scenario and scenario outline feature declarations (required: DIRECTORY=)'
  task :test_count do
    directory     = ENV['DIRECTORY'] || './'
    tag_to_count  = ENV['TAG']
    counts = Reports.test_count(directory, tag_to_count)
    printf "\n%-20s\n\n", "#{counts.tag_count} Scenarios with tag: #{tag_to_count}" unless tag_to_count.nil?
    printf "%-20s\n", 'Automated Tests'
    printf "%-20s\n", '==================================='
    printf "%-20s %s\n", counts.scenarios.to_s, 'Scenarios'
    printf "%-20s %s\n", counts.skipped_scenarios.to_s, 'Skipped Scenarios'
    printf "%-20s %s\n", counts.scenario_outlines.to_s, 'Scenario Outlines'
    printf "%-20s %s\n", counts.data_rows.to_s, 'Example Data Rows'
    printf "%-20s\n", '==================================='
    printf "%-20s %s\n", counts.total.to_s, 'TOTAL (Scenarios - Skipped + Example Data Rows)'
  end
end
