require 'selenium-webdriver'

module Browser
  def self.start(scenario, session_dir)
    @session_dir = session_dir
    @profile = send("#{BROWSER}_caps")

    if Grid.on?
      Browserstack.on? ? browserstack(scenario) : grid
    else
      Watir::Browser.new BROWSER.to_sym, @profile
    end
  end

  def self.browserstack(scenario)
    Watir::Browser.new :remote, url: Browserstack.hub_url, desired_capabilities: Browserstack.caps(scenario)
  end

  def self.grid
    Watir::Browser.new BROWSER.to_sym, url: Grid.hub_url
  end

  def self.firefox_caps
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.dir'] = @session_dir
    profile['browser.download.folderList'] = 2
    profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/pdf,text/plain,application/octet-stream,application/vnd.ms-excel'
    { profile: profile }
  end

  def self.chrome_caps
    caps = {
      options:
        {
          prefs: chrome_prefs
        },
      headless: HEADLESS
    }

    caps[:options][:args] = ['--no-sandbox'] if HEADLESS
    caps
  end

  def self.chrome_prefs
    {
      download:
        {
          prompt_for_download: false,
          default_directory: @session_dir
        }
    }
  end

  def self.safari_caps
    {}
  end

  def self.edge_caps
    {}
  end
end
