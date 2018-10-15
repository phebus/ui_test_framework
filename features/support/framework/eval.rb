require 'deep_struct'

module Framework
  module Eval
    extend self

    # @deprecated use Hash#fetch(key) instead; it will throw exception if not
    # able to find a value.
    def throw_if_missing_key(key_to_search_for, hash_set)
      return if hash_set.key? key_to_search_for

      fail 'Missing Key ' + key_to_search_for.to_s
    end

    ##
    # Desc: Utility method that will throw an exception if the passed in
    #       param value is nil.
    #
    # Params:
    #   param       - The parameter object to test for nil.
    #   param_name  - The name of the parameter being tested.
    ##
    def throw_if_nil(param, param_name)
      fail "Parameter #{param_name} is required." if param.nil?
    end

    ##
    # Desc:   Utility method that will throw an exception if the
    #         passed in param_value is nil or an empty string.
    #
    # Params:
    #   param_name  - String representing the name of the parameter to be checked
    #   param_value - The parameter to check (must be string).
    ##
    def throw_if_nil_or_empty(param_name, param_value)
      throw_if_nil(param_name, param_value)
      fail 'Specfied param_value must be a String' unless param_value.is_a?(String)
      fail "Parameter #{param_name} cannot be empty." if param_value.empty?
    end

    # Returns the path where we can find the datafiles we use for testing.
    # @return [String] - The expanded directory of the datafiles dir.
    def datafiles_dir
      File.expand_path('datafiles')
    end

    # Reads in the config file specified as a YAML file.
    # @return [Hash] HashMap of key/value pairs from the passed in YAML file.
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
