class AddCommitToBuilds < ActiveRecord::Migration[7.0]
  def change
    add_column :builds, :commit, :string
  end
end
