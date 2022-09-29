ParameterType(
  name: 'search_term',
  regexp: /I search for "([^"]*)"/,
  transformer: ->(name) { replace_variables(name) }
)

ParameterType(
  name: 'unique_id',
  regexp: /:unique_id/,
  transformer: ->(name) { replace_variables(name) }
)

ParameterType(
  name: 'action',
  regexp: /(add|remove)/,
  transformer: ->(action) { action }
)
