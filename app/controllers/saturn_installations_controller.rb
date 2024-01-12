class SaturnInstallationsController < ApplicationController
  def index
    @saturn_installations = current_user.saturn_installations
  end

  def destroy
    saturn_installation = SaturnInstallation.find(params[:id])
    saturn_installation.destroy!

    redirect_to saturn_installations_path
  end

  private

  def remove_app_installation(github_installation_id)
  end
end
