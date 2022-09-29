require 'selenium'
require 'zalenium'

class Remote
  class << self
    def on?
      raise "Only one remote target can be set. Please set either ZAL or SE4, not both" if Se4.on? && Zalenium.on?

      Se4.on? || Zalenium.on?
    end

    def caps(scenario)
      if Zalenium.on?
        Zalenium.caps(scenario)
      elsif Se4.on?
        Se4.caps(scenario)
      else
        {}
      end
    end

    def hub_url
      if HUB_ADDR && HUB_PORT
        "http://#{HUB_ADDR}:#{HUB_PORT}/wd/hub"
      elsif Zalenium.on?
        Zalenium.hub_url
      elsif Se4.on?
        Se4.hub_url
      end
    end

    private

    def build_name
      BUILD_NAME || 'UI Tests Build'
    end
  end
end
