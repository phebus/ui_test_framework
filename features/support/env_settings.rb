class EnvSettings
  # Loads a config based on the SITE environment variable or the name of the file parameter.
  #
  # @param [String] file attempts to load #{file}.yml from the configs folder
  # @return [DeepStruct] the contents of #{file}.yml or #{SITE}.yml in the configs folder
  #

  class << self
    def configs(file = nil)
      merged_product_configs = product_configs.inject(&:deep_merge)

      global_merged_with_base = if merged_product_configs.nil?
                                  global.deep_merge(base_config(file))
                                else
                                  merged_base_and_product = base_config(file).deep_merge(merged_product_configs)
                                  global.deep_merge(merged_base_and_product)
                                end

      DeepStruct.from_data(global_merged_with_base)
    end

    private

    def product_configs
      product_config_files = Dir.glob(File.dirname(__FILE__) + "/configs/**/#{SITE}/**/*.yml")

      product_config_files.map do |pcf|
        base_name = pcf.split('/').last.split('.yml').first
        { base_name => read_config_file(pcf, true) }
      end
    end

    def global
      global_file = File.dirname(__FILE__) + '/configs/global.yml'
      read_config_file(global_file, false)
    end

    def base_config(file = nil)
      file_name = file.nil? ? "#{SITE}.yml" : "#{file}.yml"
      base_config_file = Dir.glob(File.dirname(__FILE__) + "/configs/**/#{file_name}").first

      raise "Unable to find YML file \"#{base_config_file}.yml" unless File.exist?(base_config_file)

      read_config_file(base_config_file, true)
    end

    def read_config_file(yaml_file, is_template)
      if is_template
        template    = File.read(yaml_file)
        yaml_config = YAML.safe_load(ERB.new(template).result)
      else
        yaml_config = YAML.load_file(yaml_file)
      end

      DeepStruct.from_data(yaml_config)
    end
  end
end
