require 'rspec/core/formatters/base_formatter'
require 'json'

class CustomFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self, :example_failed, :dump_summary

  def initialize(output)
    super(output)
    @output_hash = []
  end

  def example_failed(notification)
    @output_hash.push({
      filename: notification.example.metadata[:file_path],
      line_number: notification.example.metadata[:line_number],
      full_description: notification.example.full_description,
      output: notification.exception.message.strip,
      backtrace: notification.exception.backtrace
    })
  end

  def dump_summary(summary)
    output.write(JSON.pretty_generate(@output_hash))
  end
end
