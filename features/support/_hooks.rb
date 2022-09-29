Before do |scenario|
  World.unique_id = @unique_id = unique_identifier
  log "Unique ID: #{@unique_id}"

  @session_dir = File.join(DOWNLOAD_OUTPUT, Time.now.to_i.to_s)

  FileUtils.makedirs(@session_dir, mode: 0o755)
  World.browser = @browser ||= ::Browser.start(scenario.name, @session_dir)

  @session_id = @browser&.driver&.instance_variable_get('@bridge')&.session_id
  log "Session ID: #{@session_id}"

  width, height = RES.split('x')
  @browser.window.resize_to(width, height)

  if Zalenium.on?
    @browser.driver.file_detector = lambda do |args|
      str = args.first.to_s
      str if File.exist?(str)
    end
  end

  if LOG_API_CALLS
    @api_log = "api_log_#{scenario.name.snake_case}.txt"
    RestClient.log = "features/output/#{@api_log}"
  end
end

After do |scenario|
  if scenario.status != :skipped
    @zal_status = true

    begin
      if scenario.failed? && !@browser.nil?
        @zal_status = false
        @browser&.screenshot&.save("features/output/#{@unique_id}.png")
        image64 = @browser.screenshot.base64
        attach(image64, 'image/png')
        log("<a href=\"#{@api_log}\">Click to view log of API calls</a>") if File.file?("features/output/#{@api_log}")
      end

      if Zalenium.on? && !@browser.nil? && @browser.url != 'data:,'
        @browser&.cookies&.add('zaleniumTestPassed', @zal_status.to_s)
      end

      @browser&.quit unless PERSISTENT
    rescue Selenium::WebDriver::Error::UnknownError, Errno::ECONNREFUSED => e
      log 'Received error during teardown: ' + e.inspect
    ensure
      if Zalenium.on? && !PERSISTENT && !@zal_status
        log("<video width=\"840\" controls><source src=\"#{Zalenium.video_url(@session_id)}\" type=\"video/mp4\"></video>")
      end

      clear_unique_identifier
      cleanup_test_assets
      FileUtils.rm_rf @session_dir
    end
  end
end
