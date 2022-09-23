$:.push(__dir__) unless $:.include?(__dir__)

require 'page-object'
require 'env_settings'
require 'zalenium'
require 'browser'
require 'world'
require 'csv'
require 'to_bool'
require 'uri'
require 'watir'
require 'oauth'
require 'parallel'
require 'core_ext/hash'
require 'deep_struct'

DOWNLOAD_OUTPUT         = ENV.fetch('DOWNLOAD_OUTPUT', 'output/downloads')
SITE                    = ENV.fetch('SITE', 'dev')
BROWSER                 = ENV.fetch('BROWSER', 'chrome')
HEADLESS                = ENV.fetch('HEADLESS', false)
RES                     = ENV.fetch('RES', '1280x720')
ZALENIUM                = ENV.fetch('ZAL', false)
SE4                     = ENV.fetch('SE4', false)
BUILD_NAME              = ENV.fetch('BUILD_NAME', 'Default Build Name')
PROJECT_NAME            = ENV.fetch('PROJECT_NAME', 'Default Project Name')
HUB_ADDR                = ENV.fetch('HUB_ADDR', nil)
HUB_PORT                = ENV.fetch('HUB_PORT', nil)
PERSISTENT              = ENV.fetch('PERSISTENT', false)
TEST_NAME               = ENV.fetch('TEST_NAME', nil) || ENV.fetch('BUILD_NAME', nil) || 'Test Default'
DEBUG                   = ENV.fetch('DEBUG', false)
LOG_API_CALLS           = ENV.fetch('LOG_API_CALLS', false)

if PERSISTENT
  driver = Browser.start(TEST_NAME, @session_dir)
  Before do
    @session_dir = File.join(DOWNLOAD_OUTPUT, Time.now.to_i.to_s)
    @browser = driver
  end

  at_exit do
    driver.quit
  end
end

if DEBUG
  Selenium::WebDriver.logger.level = :debug
end

Dir["#{File.dirname(__FILE__)}/**/*.rb"].sort.each { |f| require f }

World(PageObject::PageFactory)
World(World)
