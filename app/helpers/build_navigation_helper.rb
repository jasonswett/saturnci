class BuildNavigation
  def initialize(view_context, build, partial)
    @view_context = view_context
    @build = build
    @partial = partial
  end

  def item(text, slug)
    @view_context.link_to(
      text,
      @view_context.build_detail_content_project_build_path(@build.project, @build, slug),
      class: @partial == slug ? "active" : "",
      data: { turbo_frame: "build_details" }
    )
  end
end

module BuildNavigationHelper
  def build_navigation(build, partial, &block)
    build_navigation = BuildNavigation.new(self, build, partial)
    block.call(build_navigation)
  end
end
