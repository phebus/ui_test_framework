require 'rest-client'

module API
  class Base
    def initialize
      @client = RestClient::Resource.new(headers:)
    end

    private

    def headers
      {}
    end
  end
end
