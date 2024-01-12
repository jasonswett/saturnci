class SaturnInstallationsController < ApplicationController
  def index
    @saturn_installations = current_user.saturn_installations
  end
end
