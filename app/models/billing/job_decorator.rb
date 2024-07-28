module Billing
  class JobDecorator
    def initialize(job)
      @job = job
    end

    def charge
      @job.duration / 1000.0
    end

    def method_missing(method, *args, &block)
      @job.send(method, *args, &block)
    end
  end
end
