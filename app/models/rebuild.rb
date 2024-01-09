class Rebuild
  def self.create!(original_build)
    original_build.dup.tap do |build|
      build.report = nil
    end
  end
end
