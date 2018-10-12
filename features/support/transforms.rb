ParameterType(
  name: 'unique_id',
  regexp: /:unique_id/,
  transformer: ->(name) { replace_variables(name) }
)
