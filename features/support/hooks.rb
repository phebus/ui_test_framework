Before do |scenario|
  Framework::World.unique_id = @unique_id = unique_identifier
  @session_dir = File.join(DOWNLOAD_OUTPUT, Time.now.to_i.to_s)
  FileUtils.makedirs(@session_dir, mode: 0o755)
  Framework::World.browser = @browser ||= ::Browser.start(scenario.name, @session_dir)

  width, height = RES.split('x')
  @browser.window.resize_to(width, height)

  if Browserstack.on?
    @browser.driver.file_detector = lambda do |args|
      str = args.first.to_s
      str if File.exist?(str)
    end
  end
  puts "Unique ID: #{@unique_id}"
  puts Browserstack.job_url(@browser.driver.session_id) if Browserstack.on?
end

After do |scenario|
  if scenario.status != :skipped
    begin
      if scenario.failed? && !@browser.nil?
        Browserstack.mark_failed(@browser.driver.session_id) if Browserstack.on?
        @browser.screenshot.save("features/output/#{@unique_id}.png")
        image64 = @browser.screenshot.base64
        embed("data:image/png;base64,#{image64}", 'image/png')
      end
    ensure
      clear_unique_identifier
      cleanup_test_assets
      @browser&.quit unless PERSISTENT
      FileUtils.rm_rf @session_dir
    end
  end
end
