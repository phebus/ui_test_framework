# Replaces pattern with string substitutions described in Framework::World
Transform /:unique_id|:now/ do |step|
  replace = replaceable.select { |r| step.include?(r) }
  replace_variables(step, substitutions(replace))
end

# Gets a table as its input, does replacements
Transform /^table:/ do |table|
  # Map over the rows, columns substituting values and return the Ast::Table object.
  # Cucumber::Ast::Table.new(table.raw.map { |row| row.map { |col| col.multi_gsub(substitutions) } })

  # Have to transpose the table during this section so the mapping works correctly
  trans_table = table.transpose

  # Only replace strings that exist in the table, don't run substitutions on non-existent strings. Also these replacements
  # only work on 2 column tables (as they are meant for parameter->value replacements)
  if table.columns.length == 2
    replace = table.rows_hash.values.map { |value|
      replaceable.select { |r| value.include?(r) }.last
    }.compact
  end

  # Don't replace if nothing is replaceable.
  unless replace.to_s.empty?
    trans_table.column_names.each { |column_name|
      trans_table.map_column!(column_name) { |col|
        replace_variables(col, substitutions(replace))
      }
    }
  end
  trans_table.transpose
end
