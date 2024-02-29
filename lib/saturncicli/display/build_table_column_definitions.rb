module SaturnCICLI
  module Display
    class BuildTableColumnDefinitions
      include Enumerable

      def each(&block)
        @column_definitions.each(&block)
      end

      def initialize
        @column_definitions = {
          "id" => {
            label: "Build ID",
            format: -> (hash) { Helpers.truncated_hash(hash) }
          },

          "created_at" => {
            label: "Created",
            format: -> (value) { Helpers.formatted_datetime(value) }
          },

          "branch_name" => { label: "Branch" },

          "commit_hash" => {
            label: "Commit",
            format: -> (hash) { Helpers.truncated_hash(hash) }
          },

          "commit_message" => {
            label: "Commit message",
            format: -> (value) { Helpers.truncate(Helpers.squish(value)) }
          },

          "status" => { label: "Status" },
        }
      end
    end
  end
end
