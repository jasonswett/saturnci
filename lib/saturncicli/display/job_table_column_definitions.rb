require_relative "column_definitions"

module SaturnCICLI
  module Display
    class JobTableColumnDefinitions < ColumnDefinitions
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
