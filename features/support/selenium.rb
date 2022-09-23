class Se4
  class << self
    def on?
      !!SE4 && !SE4.empty?
    end

    def caps(scenario)
      {
        'se:name':        "Scenario: #{scenario}",
        'se:build':       BUILD_NAME,
        'se:idleTimeout': 300,
        'se:recordVideo': true
      }
    end

    def hub_url
      'http://selenium-router.selenium:80/wd/hub'
    end
  end
end
