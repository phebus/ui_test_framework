class ScenarioEntry
  attr_accessor :path, :line, :name, :tags, :feature

  def initialize(path_line:, name:, feature:, tags: nil)
    @path_line              = path_line
    @path                   = path_line.split(':').first
    @line                   = path_line.split(':').last.to_i
    @name, @feature, @tags  = name, feature, tags

    @tags += tag_line.split if tag_line.start_with? '@'
  end

  def to_s
    "#{@path_line}\n\t#{name}"
  end

  def to_s_for_run
    @path_line
  end

  def hash
    path.hash ^ line.hash ^ name.hash ^ tags.hash
  end

  def title_line
    feature.lines[line - 1]
  end

  def tag_line
    feature.lines[line - 2]
  end

  def eql?(other)
    path == other.path && line == other.line && name == other.name && tags == other.tags
  end

  def outline?
    title_line.include? 'Outline'
  end

  # Find the example rows in a scenario outline
  def example_rows
    return [] unless outline?

    feature.lines[examples_start..examples_end]
  end

  def examples_end
    feature.lines[examples_start..-1].each_with_index do |example, index|
      return index + examples_start - 1 unless example.start_with?('|')
      return index + examples_start if index == feature.lines[examples_start..-1].size - 1
    end
  end

  def examples_start
    feature.lines[line..-1].each_with_index do |value, index|
      return index + line + 2 if value.start_with?('Examples:')
    end
  end
end
