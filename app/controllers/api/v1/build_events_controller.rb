class API::V1::BuildEventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    build = Build.find(params[:build_id])
    build.build_events.create!(type: params[:type])
  end
end
