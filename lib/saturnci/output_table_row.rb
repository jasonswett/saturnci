require_relative "cli_helpers"

module SaturnCI
  class OutputTableRow
    def initialize(item, columns)
      @item = item
      @columns = columns
    end

    def format
      [
        formatted_attribute("branch_name"),
        formatted_attribute("commit_hash"),
        CLIHelpers.truncate(formatted_attribute("commit_message").squish),
      ].join(@spacer)
    end

    private

    def formatted_attribute(attribute)
      @item[attribute].ljust(column(attribute).ljust_length)
    end

    def column(attribute)
      @columns.find { |c| c.attribute == attribute }
    end
  end
end
