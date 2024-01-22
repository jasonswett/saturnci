class AddSeedToBuilds < ActiveRecord::Migration[7.1]
  def change
    Build.destroy_all
    add_column :builds, :seed, :integer, null: false
  end
end
