module Browser
  module Profile
    def self.for(browser, session_dir = DOWNLOAD_OUTPUT)
      const_get(browser.to_s.capitalize).new(session_dir)
    end

    class Chrome < Selenium::WebDriver::Chrome::Profile
      def initialize(session_dir)
        super()

        self['download.prompt_for_download'] = false
        self['download.default_directory'] = session_dir
      end
    end

    class Firefox < Selenium::WebDriver::Firefox::Profile
      def initialize(session_dir)
        super()

        self['browser.download.dir'] = session_dir
        self['browser.download.folderList'] = 2
        self['browser.helperApps.neverAsk.saveToDisk'] = 'application/pdf,text/plain,application/octet-stream'
      end
    end
  end
end
