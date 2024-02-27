require "json"
require_relative "api_request"
require_relative "display/output_table"

module SaturnCICLI
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
      response = request("builds")
      puts OutputTable.new(JSON.parse(response.body)).to_s
    end

    private

    def request(endpoint)
      APIRequest.new(self, endpoint).response
    end
  end
end
