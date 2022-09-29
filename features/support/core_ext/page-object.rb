module PageObject
  def wait_until(timeout: 60, message: nil, &block)
    platform.wait_until(timeout:, message:, &block)
  end

  def wait_while(timeout: 60, message: nil, &block)
    platform.wait_while(timeout:, message:, &block)
  end
end
