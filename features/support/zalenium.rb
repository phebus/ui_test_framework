class Zalenium
  class << self
    def on?
      !!ZALENIUM && !ZALENIUM.empty?
    end

    def caps(scenario)
      {
        'zal:name':        "Scenario: #{scenario}",
        'zal:build':       BUILD_NAME,
        'zal:idleTimeout': 300
      }
    end

    def hub_url
      'http://zalenium-test-app.zalenium-test:80/wd/hub'
    end

    def video_url(session_id)
      tries ||= 1000

      response     = JSON.parse(RestClient.get(HUB_ADDR + '/dashboard/information'))
      session_info = response.find { |r| r['seleniumSessionId'] == session_id }
      file_name    = session_info['fileName']
      build        = session_info['build'].tr(' ', '_')

      "https://zalenium.vitalbook.com/dashboard/#{build}/#{file_name}"
    rescue NoMethodError
      retry unless (tries -= 1).zero?
    end
  end
end
