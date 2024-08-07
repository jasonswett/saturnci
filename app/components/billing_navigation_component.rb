# frozen_string_literal: true

class BillingNavigationComponent < ViewComponent::Base
  attr_reader :year, :month

  def initialize(project:, year:, month:)
    @project = project
    @year = year.presence || Time.current.year
    @month = month.presence || Time.current.month
  end

  def dates
    @project.jobs
      .select("to_char(jobs.created_at, 'YYYY-MM') as month")
      .order("month desc")
      .map(&:month)
      .uniq
      .map { |month_string| month_string.split("-") }
  end
end
