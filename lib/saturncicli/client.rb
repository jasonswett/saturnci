require "json"
require_relative "api_request"
require_relative "display/table"

module SaturnCICLI
  class Client
    DEFAULT_HOST = "http://localhost:3000"
    attr_reader :host, :username, :password

    def initialize(username:, password:, host: DEFAULT_HOST)
      @username = username
      @password = password
      @host = host
      request("builds")
    end

    def execute(argument)
      case argument
      when "jobs"
        jobs
      when "builds"
        builds
      else
        builds
      end
    end

    def builds(options = {})
      response = request("builds")
      builds = JSON.parse(response.body)

      puts Display::Table.new(
        column_definitions: :build,
        items: builds,
        options: options
      )
    end

    def jobs(options = {})
      response = request("jobs")
      jobs = JSON.parse(response.body)
      puts Display::OutputTable.new(jobs, options).to_s
    end

    private

    def request(endpoint)
      APIRequest.new(self, endpoint).response
    end
  end
end
