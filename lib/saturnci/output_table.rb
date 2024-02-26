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
      HEADINGS.map do |attribute, label|
        values = @items.map { |item| item[attribute] }
        OutputTableColumn.new(
          attribute: attribute,
          label: label,
          values: values,
          spacer: SPACER
        ).formatted_heading
      end.join.strip
    end

    def formatted_items
      @items.map do |item|
        OutputTableRow.new(item, SPACER).format
      end
    end
  end
end
