class AddCommitMessageToBuilds < ActiveRecord::Migration[7.0]
  def change
    add_column :builds, :commit_message, :string
  end
end
