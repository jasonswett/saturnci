require_relative "cli_helpers"

module SaturnCI
  class OutputTableRow
    def initialize(item, spacer)
      @item = item
      @spacer = spacer
    end

    def format
      [
        @item["branch_name"],
        @item["commit_hash"],
        CLIHelpers.truncate(@item["commit_message"])
      ].join(@spacer)
    end
  end
end
