module Streaming
  class JobOutputStream
    def initialize(job:, tab_name:)
      @job = job
      @tab_name = tab_name
    end

    def name
      "job_#{@job.id}_#{@tab_name}"
    end
  end
end
