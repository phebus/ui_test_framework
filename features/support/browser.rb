require 'remote'

module Browser
  def self.start(scenario, session_dir)
    @session_dir = session_dir
    @watir_opts  = send("#{BROWSER}_caps")

    if Remote.on?
      remote(scenario)
    else
      Watir::Browser.new BROWSER.to_sym, options: @watir_opts, headless: HEADLESS
    end
  end

  def self.remote(scenario)
    tries ||= 3

    Watir::Browser.new BROWSER.to_sym, options: Remote.caps(scenario).merge!(@watir_opts),
                       url:                     Remote.hub_url,
                       http_client:             { read_timeout: 600, open_timeout: 600 }
  rescue Selenium::WebDriver::Error::UnknownError, Errno::ECONNREFUSED, Errno::ETIMEDOUT => e
    Kernel.puts 'Error starting browser, retrying: ' + e.inspect
    retry unless (tries -= 1).zero?
  end

  def self.firefox_caps
    {}
  end

  def self.chrome_caps
    {
      prefs: {
        download: {
          prompt_for_download: false,
          default_directory:   @session_dir
        }
      },
      args:  %w[--no-sandbox --disable-dev-shm-usage]
    }
  end

  def self.edge_caps
    {}
  end
end
