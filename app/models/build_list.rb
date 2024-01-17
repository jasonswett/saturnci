class BuildList
  def initialize(build, branch_name:)
    @build = build
    @branch_name = branch_name
  end

  def builds
    builds = @build.project.builds.order("created_at desc")

    if @branch_name.present?
      builds = builds.where(branch_name: @branch_name)
    end

    builds
  end

  def branch_names
    @build.project.builds.map(&:branch_name).uniq
  end
end
