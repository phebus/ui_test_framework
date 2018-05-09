$:.push(__dir__) unless $:.include?(__dir__)

require 'page-object'
require 'env_settings'
require 'framework/core'
require 'framework/eval'
require 'framework/world'
require 'browserstack'
require 'browser'
require 'grid'
require 'csv'
require 'uri'
require 'watir-scroll'

DOWNLOAD_OUTPUT         = ENV['DOWNLOAD_OUTPUT'] || 'output/downloads'
SITE                    = ENV['SITE'] || 'dev'
BROWSER                 = ENV['BROWSER'] || 'chrome'
HEADLESS                = ENV['HEADLESS'] || false
DEVICE                  = ENV['DEVICE'] || ''
BROWSER_VERSION         = ENV['VERSION'] || nil
OS                      = ENV['OS'] || 'any'
OS_VERSION              = ENV['OS_VERSION'] || 'any'
RES                     = ENV['RES'] || '1024x768'
BROWSERSTACK            = ENV['BS'] || false
BS_NAME                 = ENV['BS_NAME']
BS_KEY                  = ENV['BS_KEY']
BS_NET_LOGS             = ENV['BS_NET_LOGS'] || 'false'
SE_VERSION              = ENV['SE_VERSION'] || ''
BUILD_NAME              = ENV['BUILD_NAME']
PROJECT_NAME            = ENV['PROJECT_NAME']
GRID                    = ENV['GRID']
HUB_ADDR                = ENV['HUB_ADDR'] || '127.0.0.1'
HUB_PORT                = ENV['HUB_PORT'] || '4444'
PERSISTENT              = ENV['PERSISTENT'] || false
TEST_NAME               = ENV['TEST_NAME'] || 'UI Test Default'
DEBUG                   = ENV['DEBUG'] || false

if PERSISTENT
  driver = ::Browser.start(TEST_NAME, @session_dir)
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

World(PageObject::PageFactory)
World(Framework::Core)
World(Framework::Eval)
World(Framework::World)
