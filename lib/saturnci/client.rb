require "net/http"
require "uri"
require "json"

module SaturnCI
  class Client
    DEFAULT_HOST = "http://localhost:3000"

    def initialize(username:, password:, host: DEFAULT_HOST)
      @username = username
      @password = password
      @host = host
      builds
    end

    def builds
      uri = URI("#{@host}/api/v1/builds")
      request = Net::HTTP::Get.new(uri)
      request.basic_auth @username, @password

      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      raise "Bad credentials." if response.code != "200"
      JSON.parse(response.body)
    end
  end
end
