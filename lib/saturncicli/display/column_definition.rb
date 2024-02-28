module SaturnCICLI
  module Display
    class ColumnDefinition
      def self.find(resource_name)
        column_definition_class(resource_name).new
      end

      def self.column_definition_class(resource_name)
        require_relative "#{resource_name}_table_column_definitions"
        Object.const_get(class_name(resource_name))
      end

      def self.class_name(resource_name)
        "SaturnCICLI::Display::#{resource_name.to_s.capitalize}TableColumnDefinitions"
      end
    end
  end
end
