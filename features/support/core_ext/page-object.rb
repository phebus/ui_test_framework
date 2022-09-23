module PageObject
  def wait_until(timeout: 60, message: nil, &block)
    platform.wait_until(timeout: timeout, message: message, &block)
  end

  def wait_while(timeout: 60, message: nil, &block)
    platform.wait_while(timeout: timeout, message: message, &block)
  end
end
