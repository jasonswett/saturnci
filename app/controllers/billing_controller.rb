class BillingController < ApplicationController
  def index
    @project = Project.find(params[:project_id])

    year = params[:year].presence || Time.current.year
    month = params[:month].presence || Time.current.month
    start_date = Date.new(year.to_i, month.to_i, 1)
    end_date = start_date.end_of_month

    @jobs = @project.jobs
      .where(created_at: start_date..end_date)
      .order("jobs.created_at desc")
      .map { |job| Billing::JobDecorator.new(job) }

    @dates = @project.jobs
      .select("to_char(jobs.created_at, 'YYYY-MM') as month")
      .order("month desc")
      .map(&:month)
      .uniq
      .map { |month_string| month_string.split("-") }
  end
end
