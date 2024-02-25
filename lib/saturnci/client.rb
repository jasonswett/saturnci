require "json"
require_relative "api_request"

module SaturnCI
  class Client
    DEFAULT_HOST = "http://localhost:3000"
    attr_reader :host, :username, :password

    def initialize(username:, password:, host: DEFAULT_HOST)
      @username = username
      @password = password
      @host = host
      builds
    end

    def builds
      response = APIRequest.new(self, "builds").response
      JSON.parse(response.body)
    end
  end
end
