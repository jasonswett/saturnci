class RebuildsController < ApplicationController
  def create
    original_build = Build.find(params[:build_id])
    build = original_build.dup
    build.start!

    redirect_to build.project
  end
end
