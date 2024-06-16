module Streaming
  class JobOutputStream
    def initialize(job:, tab_name:)
      @job = job
      @tab_name = tab_name
    end

    def name
      "job_#{@job.id}_#{@tab_name}"
    end

    def target
      "build_details_content_#{@tab_name}"
    end

    def partial
      "jobs/#{@tab_name}"
    end

    def locals
      { job: @job, current_tab_name: @tab_name }
    end

    def broadcast
      Turbo::StreamsChannel.broadcast_update_to(
        name,
        target: target,
        partial: partial,
        locals: locals
      )
    end
  end
end
