module API
  module V1
    class BuildsController < APIController
      def create
        project = Project.first
        project.builds.create!
      end
    end
  end
end
