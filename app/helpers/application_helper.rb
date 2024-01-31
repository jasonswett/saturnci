module ApplicationHelper
  def abbreviated_hash(hash)
    hash[0..7]
  end

  def terminal_tag
    content = capture { yield }
    return unless content.present?

    compressed_content = content.gsub(/\n\s+/, "").html_safe
    content_tag(:pre, compressed_content, class: "terminal")
  end

  def build_navigation_link_to(text, slug, build, partial)
    link_to text, build_detail_content_project_build_path(build.project, build, slug),
      class: partial == slug ? "active" : "",
      data: { turbo_frame: "build_details" }
  end
end
