module SaturnCI
  class OutputTableColumn
    def initialize(attribute, label, values, spacer)
      @attribute = attribute
      @label = label
      @values = values
      @spacer = spacer
    end

    def formatted_heading
      @label.ljust(length_of_longest_value + @spacer.length)
    end

    def length_of_longest_value
      return 0 unless @values.any?
      @values.map(&:length).max
    end
  end
end
