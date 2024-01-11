class BuildReportRow
  def initialize(content)
    @content = content
  end

  def colorized
    "<span style=\"#{style}\">#{@content}</span>"
  end

  private

  def style
    if @content.include?('passed')
      'color: green;'
    elsif @content.include?('failed')
      'color: red;'
    else
      ''
    end
  end
end
