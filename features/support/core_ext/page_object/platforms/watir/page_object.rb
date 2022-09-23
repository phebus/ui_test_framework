module PageObject
  module Platforms
    module Watir
      class PageObject
        def wait_until(timeout: 60, message: nil, &block)
          @browser.wait_until(timeout: timeout, message: message, &block)
        end
      end
    end
  end
end
