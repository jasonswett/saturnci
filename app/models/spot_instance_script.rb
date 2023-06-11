require "net/http"
require "uri"

uri = URI("#{HOST}/api/v1/builds/#{BUILD_ID}/events")

http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.path)

form_data = { "event" => "spot_instance_ready" }
request.set_form_data(form_data)

http.request(request)
