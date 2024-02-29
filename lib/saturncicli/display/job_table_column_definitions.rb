module SaturnCICLI
  module Display
    class JobTableColumnDefinitions
      include Enumerable

      class << self
        attr_accessor :column_definitions
      end

      def self.define_columns(&block)
        self.column_definitions = block.call
      end

      def each(&block)
        self.class.column_definitions.each(&block)
      end

      define_columns do
        {
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
end
