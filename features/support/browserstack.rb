require 'rest-client'

class Browserstack
  class << self
    def on?
      !!BROWSERSTACK && !BROWSERSTACK.empty?
    end

    def caps(scenario)
      caps                                    = Selenium::WebDriver::Remote::Capabilities.new
      caps['browserstack.debug']              = 'true'
      caps['browserstack.selenium_version']   = SE_VERSION
      caps['browserstack.networkLogs']        = BS_NET_LOGS
      caps[:name]                             = "Scenario: #{scenario}"
      caps[:build]                            = build_name
      caps[:project]                          = project_name
      caps.merge!(cap_hash)
      caps
    end

    def cap_hash
      {
        browser: BROWSER,
        browserName: BROWSER,
        browser_version: BROWSER_VERSION,
        os: OS,
        os_version: OS_VERSION,
        device: DEVICE
      }
    end

    def hub_url
      verify_environment
      "http://#{BS_NAME}:#{BS_KEY}@hub.browserstack.com/wd/hub"
    end

    def job_url(session_id)
      client["builds/#{build_id}/sessions/#{session_id}"]
    end

    def mark_failed(session_id)
      client["sessions/#{session_id}.json"].put({ status: 'error' }.to_json, content_type: :json)
    end

    private

    def project_name
      PROJECT_NAME || 'UI Tests'
    end

    def build_name
      BUILD_NAME || 'UI Tests Build'
    end

    def builds
      JSON.parse(client['builds.json'].get)
    end

    def build_id
      builds.select do |build|
        build['automation_build']['name'] == build_name
      end.first['automation_build']['hashed_id']
    rescue NoMethodError
      puts 'Could not find Browserstack build but test is still running, please see http://browserstack.com/automate to
find your build'
    end

    def client
      RestClient::Resource.new EnvSettings.configs.browserstack.api_base, user: BS_NAME, password: BS_KEY
    end

    def verify_environment
      raise 'BS_NAME and BS_KEY need to be set in order to use Browserstack' unless !!BS_NAME && !!BS_KEY
      true
    end
  end
end
