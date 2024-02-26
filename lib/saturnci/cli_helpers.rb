module SaturnCI
  module CLIHelpers
    DEFAULT_TRUNCATION_THRESHOLD = 40

    def self.truncate(text)
      return text if text.length <= DEFAULT_TRUNCATION_THRESHOLD
      "#{text[0..DEFAULT_TRUNCATION_THRESHOLD].strip}..."
    end
  end
end
