module Framework
  module World
    class << self
      attr_accessor :browser, :unique_id
    end

    # Used every time replace_variables is called. Handles string replacement in step definitions
    # @see #replace_variables
    # @see #replaceable
    def substitutions(replace = replaceable)
      @substitutions = replace.each_with_object([]) do |sub_str, sub_pairs|
        sub_pairs << [Regexp.new(sub_str), send(sub_str[1..-1])]
      end
    end

    # @return [String] Unique string/id created at the beginning of a test scenario
    def unique_id
      @unique_id ||= @unique_string
    end

    # @return [String] The time that it is now
    def now
      Time.now.to_i.to_s
    end

    # Used in step transformations to replace keywords with other things at runtime
    # @param string [String] Usually a step definition
    # @param replacements [Array] Array of arrays of substitution pairs
    # @see transforms.rb
    # @see String#multi_gsub
    def replace_variables(string, replacements = nil)
      String(string).multi_gsub(replacements)
    end

    # @return [Array] Array of replaceable strings in steps/tables
    def replaceable
      %w(:unique_id :now)
    end

    # Runs various methods to clean up test assets created during a run
    def cleanup_test_assets
      true
    end
  end
end
