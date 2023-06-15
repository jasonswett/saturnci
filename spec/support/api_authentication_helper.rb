module APIAuthenticationHelper
  def api_authorization_headers
    username = ENV["SATURNCI_API_USERNAME"]
    password = ENV["SATURNCI_API_PASSWORD"]
    encoded_credentials = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
    { "Authorization" => encoded_credentials }
  end
end
