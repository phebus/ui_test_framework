module PageObject
  module Elements
    class Element
      def wait_until(timeout: 60, message: nil, &block)
        element.wait_until(timeout:, message:, &block)
      end

      def wait_while(timeout: 60, message: nil, &block)
        element.wait_while(timeout:, message:, &block)
      end
    end
  end
end
