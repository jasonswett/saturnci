class AddTestOutputToBuilds < ActiveRecord::Migration[7.0]
  def change
    add_column :builds, :test_output, :text
  end
end
