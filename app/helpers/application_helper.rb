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
end
