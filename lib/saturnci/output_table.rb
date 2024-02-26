require_relative "output_table_row"

module SaturnCI
  class OutputTable
    SPACER = "  "

    HEADINGS = {
      "branch_name" => "Branch",
      "commit_hash" => "Commit",
      "commit_message" => "Commit message"
    }

    def initialize(items)
      @items = items
    end

    def to_s
      [header, formatted_items].join("\n")
    end

    private

    def header
      HEADINGS.map do |attribute, heading|
        column_heading(attribute, heading)
      end.join.strip
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
        OutputTableRow.new(item, SPACER).format
      end
    end
  end
end
