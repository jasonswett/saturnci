module API
  module V1
    class APIController < ApplicationController
      skip_before_action :verify_authenticity_token

      http_basic_authenticate_with(
        name: ENV["SATURNCI_API_USERNAME"],
        password: ENV["SATURNCI_API_PASSWORD"]
      )
    end
  end
end
