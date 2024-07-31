class BillingReport
  def initialize(project:, year:, month:)
    @project = project
    @year = year
    @month = month
  end

  def jobs
    @jobs ||= @project.jobs
      .where(created_at: start_date..end_date)
      .order("jobs.created_at desc")
      .map { |job| Billing::JobDecorator.new(job) }
  end

  def start_date
    Date.new(@year.to_i, @month.to_i, 1)
  end

  def end_date
    start_date.end_of_month
  end
end
