module SaturnCICLI
  class OutputTableColumn
    attr_accessor :attribute

    def initialize(attribute:, label:, values:, spacer:)
      @attribute = attribute
      @label = label
      @values = values
      @spacer = spacer
    end

    def formatted_heading
      @label.ljust(ljust_length)
    end

    def ljust_length
      length_of_longest_item + @spacer.length
    end

    private

    def length_of_longest_item
      [length_of_longest_value, @label.length].max
    end

    def length_of_longest_value
      return 0 unless @values.any?
      @values.map(&:length).max
    end
  end
end
