require 'timeout'
require 'date'

module Framework
  module Core
    extend self
    ##
    #
    ##
    def unique_identifier
      if @unique_string.nil?
        @unique_string = "#{unique_string}_#{random_string(5, false, false)}"
      end
      @unique_string
    end

    def clear_unique_identifier
      @unique_string = nil
    end

    ##
    # Desc:   Returns a unique id using a date/time stamp.
    ##
    def unique_string
      Time.now.strftime('%y%m%d%H%M%S%L')
    end

    ##
    # Desc:   Save the input object to a file on tmp/.
    ##
    def debug_log(id, txt)
      fail 'Input id object must be of type string.' unless id.is_a?(String)
      fail 'Input txt object must be of type string.' unless txt.is_a?(String)

      file_name = "tmp/debug_output_#{id}.log"
      fp        = File.open(file_name, 'w+')
      fp.write(txt)
      fp.close
    end

    ##
    # Desc:   Utility method to be used when you need to wait for a particular
    #         block of code to return true, or timeout, whichever comes first.
    #
    # Params:
    #   timeout           - Optionally specify the number of seconds to timeout. Defaults to 30
    #   message           - Optionally specify a message that will be appended to the exception if
    #                       the method times out.
    #   &block    - Block of code to execute.
    #
    # Usage:
    #   Utils.wait_until do
    #     Some code that returns a boolean
    #   end
    #
    #   Utils.wait_until(5, "waiting for control to be enabled") do
    #     Some code that returns a boolean
    #   end
    ##
    def wait_until(timeout = 60, message = nil)
      end_time = Time.now + timeout
      until Time.now > end_time
        result = yield(self)
        return result if result
        sleep 0.5
      end
      fail Timeout::Error, "Timeout occurred after #{timeout} seconds #{message}"
    end

    ##
    # Desc:   Utility method to be used when you need to wait for a particular
    #         block of code to return true or false.
    #
    # Params:
    #   timeout           - Optionally specify the number of seconds to timeout. Defaults to 30
    #   message           - Optionally specify a message that will be appended to the exception if
    #                       the method times out.
    #   &block    - Block of code to execute.
    #
    # Usage:
    #   Utils.wait_until do
    #     Some code that returns a boolean
    #   end
    #
    #   Utils.wait_until(5, "waiting for control to be enabled") do
    #     Some code that returns a boolean
    #   end
    ##
    def wait_until?(timeout = 60)
      wait_until(timeout) do
        yield
      end
    rescue (Timeout::Error)
      false
    end

    ##
    # Desc:   Searches the download directory for this test run (using the test_id) and
    #         returns the full path of the file with the newest file date.
    #
    # Params:
    #   test_id   - The id of the current test (used in retrieving the download path)
    ##
    def last_downloaded_file(test_id)
      search_dir = File.join(DOWNLOAD_OUTPUT, test_id.to_s)
      file_names = nil
      wait_until(30, "waiting for a downloaded file to exist in '#{search_dir}'") do
        file_names = Dir.glob(File.join(search_dir, '*'))
        next if file_names.empty?
        # sort and get the last file created
        # (unless it ends with .part as this is how firefox downloads partial files).
        file_names.sort! { |f1, f2| File.mtime(f1) <=> File.mtime(f2) }
        File.extname(file_names.last) != '.part'
      end
      file_names.last
    end

    ##
    # Desc: Reads in a downloaded file (using the DOWNLOAD_OUTPUT path)
    #       and returns a string containing the file contents.
    #
    # Params:
    #   test_id     - The unique id of the test. This is used as part of the path that
    #                 files are downloaded to by default.
    #   file_name   - The name of the file to read without the path.
    #   file_type   - The type of file to read. Defaults to :text
    #                 Supported Types:
    #                     text
    #                     pdf
    # Note:   This method uses the gem pdf_reader to read pdf contents to text.
    #         However, there appears to be a flaw in the reader with some pdf file
    #         where it removes any white space from the text.  Be aware of this when checking
    #         the returned text against some other value.
    ##
    def read_downloaded_file(test_id, file_name, file_type = 'text')
      file_name = File.join(DOWNLOAD_OUTPUT, test_id.to_s, file_name)
      wait_for_file(file_name)

      case file_type
      when 'text'
        IO.readlines(file_name)
      when 'pdf'
        PDF::Reader.new(file_name).pages.map(&:text).join
      else
        raise "Invalid file type: #{file_type}"
      end
    end

    def wait_for_file(file_name)
      wait_until(30, "waiting to obtain a lock on downloaded file '#{file_name}'") do
        File.exist?(file_name)
      end
    end

    ##
    # Returns the absolute path to the file on disk if it exists.  If it doesn't exists,
    #         an exception is raised.
    # Params:
    #   file_name - the file name as it exists on disk.
    ##
    def absolute_path_to_file(file_name)
      path_to_file = File.expand_path("./datafiles/#{file_name}")
      file_exists?(path_to_file)
      path_to_file
    end

    ##
    # Raises an exception if the file doesn't exist.
    #
    # Params:
    #   file_name - the file name as it exists on disk.
    ##
    def file_exists?(absolute_path)
      raise 'The filename you provided does not exist.' unless File.exist?(absolute_path)
    end

    ##
    # Desc:   Searches for a header that has a text property that matches the specified header_text
    #         by searching all header types (h1-h6) for one that matches, and if found, returns the
    #         header.
    #
    # Params:
    #   container   - Control container to search
    #   header_text - Text to use in the search
    ##
    def find_header(container, header_text)
      container.h1(:xpath, "//h1[contains(text(), '#{header_text}')]") ||
        container.h2(:xpath, "//h2[contains(text(), '#{header_text}')]") ||
        container.h3(:xpath, "//h3[contains(text(), '#{header_text}')]") ||
        container.h4(:xpath, "//h4[contains(text(), '#{header_text}')]") ||
        container.h5(:xpath, "//h5[contains(text(), '#{header_text}')]") ||
        container.h6(:xpath, "//h6[contains(text(), '#{header_text}')]")
    end

    ##
    # Desc: Truncates the given string to the specified length. Note that
    #       the ellipses (...) notation will be used for the last three characters
    #       of the string when it is returned.
    #
    # Params:
    #   string  - String to truncate.
    #   length  - Length to truncate to.
    ##
    def truncate_string(string, length)
      return if length.zero?
      return string unless string.length > length

      etc = '...'

      length -= etc.length # 27
      substring_plus_one = string[0..length]
      string = substring_plus_one.sub(/\s+?(\S+)?$/, '')
      string[0..length - 1] + etc
    end

    ##
    # Returns a random alpha-numeric (with spaces) string.
    #
    # Params:
    #   length          - The length you want your random string.
    #   include_spaces  - Set to false to not include spaces in the string (defaults to true)
    #   use_upper_case  - Set to false to not generate any upper case letters
    ##
    def random_string(length, include_spaces = true, use_upper_case = true)
      alphanumerics = use_upper_case ? [('0'..'9'), ('A'..'Z'), ('a'..'z')] : [('0'..'9'), ('a'..'z')]
      alphanumerics.push(' ') if include_spaces
      alphanumerics = alphanumerics.map(&:to_a).flatten
      # Iterate through and take one random character for 0 to length and join it into our result
      (0...length.to_i).map { alphanumerics[Kernel.rand(alphanumerics.size)] }.join
    end
  end
end
