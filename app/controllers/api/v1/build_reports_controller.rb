class API::V1::BuildReportsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    build = Build.find(params[:build_id])
    build.update!(report: params[:build_report][:_json])
  end
end
