require_relative "output_table_row"
require_relative "output_table_column"

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
      columns.map(&:formatted_heading).join.strip
    end

    def columns
      HEADINGS.map do |attribute, label|
        OutputTableColumn.new(
          attribute: attribute,
          label: label,
          values: @items.map { |item| item[attribute] },
          spacer: SPACER
        )
      end
    end

    def formatted_items
      @items.map do |item|
        OutputTableRow.new(item, columns).format
      end
    end
  end
end
