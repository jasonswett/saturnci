class AddReportToBuilds < ActiveRecord::Migration[7.0]
  def change
    add_column :builds, :report, :jsonb
  end
end
