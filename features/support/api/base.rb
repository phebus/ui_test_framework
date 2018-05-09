require 'active_support/core_ext/hash'
require 'rest-client'

module API
  class Base
    def initialize
      @client = RestClient::Resource.new(headers: headers)
    end

    private

    def headers
      {}
    end
  end
end
