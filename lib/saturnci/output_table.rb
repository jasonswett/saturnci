require_relative "cli_helpers"

module SaturnCI
  class OutputTable
    SPACER = "  "

    def initialize(items)
      @items = items
    end

    def to_s
      [header, formatted_items].join("\n")
    end

    private

    def header
      [
        column_heading("branch_name", "Branch"),
        column_heading("commit_hash", "Commit"),
        column_heading("commit_message", "Commit message")
      ].join.strip
    end

    def column_heading(attribute, label)
      label.ljust(length_of_longest(attribute) + SPACER.length)
    end

    def length_of_longest(attribute)
      return 0 unless @items.any?
      @items.map { |item| item[attribute].length }.max
    end

    def formatted_items
      @items.map do |item|
        [
          item["branch_name"],
          item["commit_hash"],
          CLIHelpers.truncate(item["commit_message"])
        ].join(SPACER)
      end.join("\n")
    end
  end
end
