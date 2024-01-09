class RebuildsController < ApplicationController
  def create
    original_build = Build.find(params[:build_id])
    build = Rebuild.create!(original_build)
    build.start!

    redirect_to build.project
  end
end
