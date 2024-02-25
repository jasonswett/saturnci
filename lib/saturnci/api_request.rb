require "net/http"
require "uri"

module SaturnCI
  class APIRequest
    def initialize(client, endpoint)
      @client = client
      @endpoint = endpoint
    end

    def response
      uri = URI("#{@client.host}/api/v1/#{@endpoint}")
      request = Net::HTTP::Get.new(uri)
      request.basic_auth @client.username, @client.password

      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      raise "Bad credentials." if response.code != "200"
      response
    end
  end
end
