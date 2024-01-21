class Rebuild
  def self.create!(original_build)
    Build.create!(
      project: original_build.project,
      branch_name: original_build.branch_name,
      commit_hash: original_build.commit_hash,
      commit_message: original_build.commit_message,
      author_name: original_build.author_name
    )
  end
end
