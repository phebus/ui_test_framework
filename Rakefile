lib = __dir__ + '/features/support'
$:.push(__dir__) unless $:.include?(__dir__)
$:.push(lib) unless $:.include?(lib)
Dir.glob('lib/tasks/*.rake').each { |r| import r }

require 'features/support/env_settings'
require 'bundler/setup'
require 'lib/reports'
