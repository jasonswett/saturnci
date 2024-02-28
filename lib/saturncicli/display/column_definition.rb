module SaturnCICLI
  module Display
    class ColumnDefinition
      def self.find(resource_name)
        require_relative "#{resource_name}_table_column_definitions"
        class_name = "SaturnCICLI::Display::#{resource_name.to_s.capitalize}TableColumnDefinitions"
        Object.const_get(class_name).new
      end
    end
  end
end
