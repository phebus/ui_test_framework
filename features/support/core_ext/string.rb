class String
  # Applies multiple substitutions to the string.
  #
  # @param substitutions [Array] An array of arrays, which is to be applied sequentially gsub
  #   statements.
  # @return [String] result of applying all statements in the Array
  # @example
  #   :foo.multi_gsub([[/:foo/, 'bar'], [/bar/, 'baz']]) # => "baz"
  #
  def multi_gsub(substitutions)
    return self if empty? || substitutions.nil? # as a class method, this cannot be nil.

    string = dup # not a ! method.

    substitutions.inject(string) do |st, substitution|
      st.gsub(*substitution) # inject makes this act like gsub! without the nil failure
    end
  end

  def snake_case
    downcase.gsub(/\s|\W/, '_') # non-word since this is usually for identifiers
  end

  def camelize(first_letter = :upper)
    return gsub(%r(/(.?))) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase } if first_letter == :upper

    self[0..0].downcase + camelize[1..]
  end

  def camel_case
    snake_case.camelize(:lower)
  end

  def class_case
    snake_case.camelize
  end
end
