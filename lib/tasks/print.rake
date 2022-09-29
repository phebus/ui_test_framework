namespace :print do
  desc 'prints all the tags currently in all feature files'
  task :all_tags do
    tags = Reports.all_tags
    printf "%-50<tag>s %<scenarios>s\n", tag: 'Tag', scenarios: 'Number of Scenarios'
    printf "%-50<ruler1>s %<ruler2>s\n", ruler1: '---', ruler2: '-------------------'
    tags.sort.each do |tag|
      printf "%-50<tag>s %<scenarios>s\n", tag:, scenarios: Reports.scenarios_with_tag(tag, Reports.all_feature_files).length
    end
  end

  desc 'prints all the scenarios matching the given tag (required: TAGS=)'
  task :scenarios_with_tags do
    Reports.output_scenarios_with_tags
  end

  desc 'prints the full file name of all the feature files that have at least one non-skipped scenario'
  task :features_to_run do
    output_file  = ENV.fetch('OUTPUT') unless ENV.fetch('OUTPUT').to_s.empty?
    feature_list = Reports.features_to_run

    Reports.output_list(feature_list, output_file)
  end

  desc "prints every scenario from every feature file in the features directory (doesn't include @skipped)"
  task :scenarios_to_run do
    Reports.scenarios_to_run
  end

  desc 'prints the number of all scenario and scenario outline feature declarations (required: DIRECTORY=)'
  task :test_count do
    directory    = ENV.fetch('DIRECTORY', './')
    tag_to_count = ENV.fetch('TAG')
    counts       = Reports.test_count(directory, tag_to_count)

    printf "\n%-20<scenarios>s\n\n", scenarios: "#{counts.tag_count} Scenarios with tag: #{tag_to_count}" unless tag_to_count.nil?
    printf "%-20<title>s\n", title: 'Automated Tests'
    printf "%-20<ruler>s\n", ruler: '==================================='
    printf "%-20<scenarios>s %<description>s\n", scenarios: counts.scenarios.to_s, description: 'Scenarios'
    printf "%-20<skipped>s %<description>s\n", skipped: counts.skipped_scenarios.to_s, description: 'Skipped Scenarios'
    printf "%-20<outlines>s %<description>s\n", outlines: counts.scenario_outlines.to_s, description: 'Scenario Outlines'
    printf "%-20<data_rows>s %<description>s\n", data_rows: counts.data_rows.to_s, description: 'Example Data Rows'
    printf "%-20<ruler>s\n", ruler: '==================================='
    printf "%-20<total>s %<description>s\n", total: counts.total.to_s, description: 'TOTAL (Scenarios - Skipped + Example Data Rows)'
  end
end
