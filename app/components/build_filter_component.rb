# frozen_string_literal: true

class BuildFilterComponent < ViewComponent::Base
  def initialize(job:, build_list:, current_tab_name:)
    @job = job
    @build_list = build_list
    @current_tab_name = current_tab_name
  end
end
