module SaturnCI
  module CLIHelpers
    def self.truncate(text)
      threshold = 40

      if text.length > threshold
        "#{text[0..threshold].strip}..."
      else
        text
      end
    end
  end
end
