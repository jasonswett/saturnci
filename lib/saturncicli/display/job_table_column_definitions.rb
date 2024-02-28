module SaturnCICLI
  module Display
    class JobTableColumnDefinitions
      include Enumerable

      def initialize
        @column_definitions = COLUMN_DEFINITIONS
      end

      def each(&block)
        @column_definitions.each(&block)
      end

      COLUMN_DEFINITIONS = {
        "build_id" => {
          label: "Build ID",
          format: -> (hash) { Helpers.truncated_hash(hash) }
        },
        "created_at" => {
          label: "Created",
          format: -> (value) { Helpers.formatted_datetime(value) }
        },
      }
    end
  end
end
