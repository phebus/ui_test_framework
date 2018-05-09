class Grid
  class << self
    def on?
      !!GRID && !GRID.empty?
    end

    def hub_url
      "http://#{HUB_ADDR}:#{HUB_PORT}/wd/hub"
    end
  end
end
