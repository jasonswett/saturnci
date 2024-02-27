require_relative "../cli_helpers"

module SaturnCICLI
  module Display
    class OutputTableRow
      def initialize(item, columns)
        @item = item
        @columns = columns
      end

      def format
        [
          formatted_attribute("branch_name"),
          formatted_attribute("commit_hash"),
          formatted_attribute("commit_message")
        ].join(@spacer).strip
      end

      private

      def formatted_attribute(attribute)
        column(attribute).formatted_value(@item[attribute])
      end

      def column(attribute)
        @columns.find { |c| c.attribute == attribute }
      end
    end
  end
end
