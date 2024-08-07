class BillingController < ApplicationController
  def index
    @project = Project.find(params[:project_id])

    @billing_navigation_component = BillingNavigationComponent.new(
      project: @project,
      year: params[:year],
      month: params[:month]
    )

    @jobs = BillingReport.new(
      project: @project,
      year: @billing_navigation_component.year,
      month: @billing_navigation_component.month
    ).jobs
  end
end
