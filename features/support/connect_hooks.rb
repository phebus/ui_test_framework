Before('@connect') do
  PageObject::JavascriptFrameworkFacade.framework = :jquery
end

Before('@distribution_sets') do
  @dist_sets = EnvSettings.configs.connect.distribution_sets
end
