class RebuildsController < ApplicationController
  def create
    original_build = Build.find(params[:build_id])
    build = Build.new(project: original_build.project)
    build.start!
  end
end
